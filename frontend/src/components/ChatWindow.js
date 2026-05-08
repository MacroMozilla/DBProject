import { useState, useRef, useEffect } from "react";
import ReactMarkdown from "react-markdown";
import remarkMath from "remark-math";
import rehypeKatex from "rehype-katex";
import remarkGfm from "remark-gfm";
import "katex/dist/katex.min.css";

const EMOJI_CATEGORIES = {
  "Smileys": ["😀","😂","🤣","😊","😍","🥰","😘","😎","🤩","🥳","😏","😢","😭","😤","🤯","🫠","🤔","🫡","🤗","🫣","😴","🥱","😈","💀","👻","🤖"],
  "Gestures": ["👍","👎","👏","🙌","🤝","✌️","🤞","🫶","💪","👋","🫵","☝️","👆","👇","👈","👉","🖐️","✋","🤙","🤟"],
  "Hearts": ["❤️","🧡","💛","💚","💙","💜","🖤","🤍","💔","❤️‍🔥","💕","💖","💗","💘","💝"],
  "Objects": ["🔥","⭐","🎉","🎊","💯","✅","❌","⚡","💡","📌","📎","🔗","🔑","🏆","🎯","📊","💻","📱","⏰","📝"],
  "Food": ["🍕","🍔","🍟","🌮","🍣","🍜","🍩","🍪","☕","🍺","🧋","🍷","🥤","🧁","🎂"],
  "Animals": ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🦁","🐮","🐷","🐸","🐵","🦄","🐝","🦋"],
  "Nature": ["🌈","☀️","🌙","⭐","🌍","🌸","🌺","🍀","🌴","🌊","❄️","🔥","💧","🌪️"],
};

const IMAGE_URL_REGEX = /(https?:\/\/\S+\.(?:gif|png|jpe?g|webp)(?:\?\S*)?)/gi;

function preprocessContent(content) {
  let processed = content.replace(IMAGE_URL_REGEX, (url) => {
    const idx = content.indexOf(url);
    if (idx > 0 && (content[idx - 1] === "(" || content[idx - 2] === "]")) return url;
    return `\n![](${url})\n`;
  });
  processed = processed.replace(/@(\w+)/g, "**@$1**");
  return processed;
}

function MessageContent({ content, isMe }) {
  const processed = preprocessContent(content);
  return (
    <ReactMarkdown
      remarkPlugins={[remarkMath, remarkGfm]}
      rehypePlugins={[rehypeKatex]}
      components={{
        img: ({ src, alt }) => (
          <img
            src={src}
            alt={alt || "shared"}
            className="max-w-full rounded-lg mt-1"
            style={{ maxHeight: "200px" }}
            onError={(e) => { e.target.style.display = "none"; }}
          />
        ),
        p: ({ children }) => <p className="my-0.5">{children}</p>,
        code: ({ children, className, ...props }) => (
          <code className={`px-1 rounded text-sm ${isMe ? "bg-white/20" : "bg-gray-300"} ${className || ""}`} {...props}>
            {children}
          </code>
        ),
        pre: ({ children }) => (
          <pre className={`p-2 rounded text-xs overflow-x-auto my-1 ${isMe ? "bg-white/10" : "bg-gray-300"}`}>
            {children}
          </pre>
        ),
        a: ({ href, children }) => (
          <a href={href} target="_blank" rel="noopener noreferrer"
             className={`underline ${isMe ? "text-blue-200" : "text-blue-600"}`}>
            {children}
          </a>
        ),
      }}
    >
      {processed}
    </ReactMarkdown>
  );
}

const ET = "America/New_York";

function toDate(postat) {
  // Backend timestamps have no tz suffix; Docker runs UTC, so append Z
  return new Date(postat + "Z");
}

function getETDateKey(postat) {
  if (!postat) return "";
  return toDate(postat).toLocaleDateString("en-CA", { timeZone: ET }); // "YYYY-MM-DD"
}

function getETMinuteKey(postat) {
  if (!postat) return "";
  const d = toDate(postat);
  const date = d.toLocaleDateString("en-CA", { timeZone: ET });
  const time = d.toLocaleTimeString("en-US", { timeZone: ET, hour: "2-digit", minute: "2-digit", hour12: false });
  return `${date}T${time}`;
}

function formatDateDivider(postat) {
  if (!postat) return "";
  return toDate(postat).toLocaleDateString("en-US", {
    timeZone: ET, month: "long", day: "numeric", year: "numeric",
  });
}

function formatTime(postat) {
  if (!postat) return "";
  return toDate(postat).toLocaleTimeString("en-US", {
    timeZone: ET, hour: "numeric", minute: "2-digit", hour12: true,
  });
}

function ChatWindow({ messages, input, setInput, sendMessage, chid, user, channelName, channelMembers = [] }) {
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [emojiCategory, setEmojiCategory] = useState("Smileys");
  const [searchActive, setSearchActive] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [mentionQuery, setMentionQuery] = useState(null);
  const [mentionIndex, setMentionIndex] = useState(0);

  const inputAreaRef = useRef(null);
  const textareaRef = useRef(null);
  const mentionRef = useRef(null);
  const searchInputRef = useRef(null);
  const messagesEndRef = useRef(null);

  const mentionResults = mentionQuery !== null
    ? channelMembers
        .filter((m) => m.status === "accepted")
        .filter((m) =>
          m.username.toLowerCase().includes(mentionQuery.toLowerCase()) ||
          (m.nickname && m.nickname.toLowerCase().includes(mentionQuery.toLowerCase()))
        )
        .slice(0, 8)
    : [];

  // Scroll to bottom whenever messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "instant" });
  }, [messages]);

  // Close emoji picker when clicking outside the input area
  useEffect(() => {
    function handleClickOutside(e) {
      if (inputAreaRef.current && !inputAreaRef.current.contains(e.target)) {
        setShowEmojiPicker(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Focus search input when activated
  useEffect(() => {
    if (searchActive) searchInputRef.current?.focus();
  }, [searchActive]);

  // Reset search when channel changes
  useEffect(() => {
    setSearchActive(false);
    setSearchQuery("");
  }, [chid]);

  const insertEmoji = (emoji) => {
    setInput((prev) => prev + emoji);
    textareaRef.current?.focus();
  };

  const handleInputChange = (e) => {
    const val = e.target.value;
    setInput(val);
    const cursorPos = e.target.selectionStart;
    const textBeforeCursor = val.slice(0, cursorPos);
    const mentionMatch = textBeforeCursor.match(/@(\w*)$/);
    if (mentionMatch) {
      setMentionQuery(mentionMatch[1]);
      setMentionIndex(0);
    } else {
      setMentionQuery(null);
    }
  };

  const selectMention = (member) => {
    const textarea = textareaRef.current;
    if (!textarea) return;
    const cursorPos = textarea.selectionStart;
    const textBeforeCursor = input.slice(0, cursorPos);
    const textAfterCursor = input.slice(cursorPos);
    const mentionMatch = textBeforeCursor.match(/@(\w*)$/);
    if (!mentionMatch) return;
    const beforeMention = textBeforeCursor.slice(0, mentionMatch.index);
    const newText = `${beforeMention}@${member.username} ${textAfterCursor}`;
    setInput(newText);
    setMentionQuery(null);
    const newCursorPos = beforeMention.length + 1 + member.username.length + 1;
    setTimeout(() => {
      textarea.focus();
      textarea.setSelectionRange(newCursorPos, newCursorPos);
    }, 0);
  };

  // Filter messages by search query
  const displayMessages = searchQuery.trim()
    ? messages.filter((m) =>
        m.content.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : messages;

  // Annotate each message: whether to show its timestamp and whether to show a date divider above it
  const annotated = displayMessages.map((msg, idx, arr) => {
    const msgMinute = getETMinuteKey(msg.postat);
    const nextMsg = arr[idx + 1];
    const showTime = !nextMsg || msgMinute !== getETMinuteKey(nextMsg.postat);

    const msgDate = getETDateKey(msg.postat);
    const prevDate = getETDateKey(arr[idx - 1]?.postat);
    const showDateDivider = idx === 0 || msgDate !== prevDate;

    return { msg, showTime, showDateDivider };
  });

  return (
    <div className="flex flex-col h-full bg-gray-100">

      {/* Header */}
      <div className="px-4 py-3 border-b bg-white font-semibold flex items-center justify-between">
        {searchActive ? (
          <>
            <input
              ref={searchInputRef}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              onKeyDown={(e) => e.key === "Escape" && (setSearchActive(false), setSearchQuery(""))}
              placeholder="Search in channel..."
              className="flex-1 text-sm font-normal focus:outline-none"
            />
            <button
              onClick={() => { setSearchActive(false); setSearchQuery(""); }}
              className="ml-2 text-gray-400 hover:text-gray-600 text-lg leading-none"
              title="Close search"
            >
              ✕
            </button>
          </>
        ) : (
          <>
            <span>{channelName ? `#${channelName}` : "Select a channel"}</span>
            {chid && (
              <button
                onClick={() => setSearchActive(true)}
                className="text-gray-400 hover:text-gray-600 ml-2"
                title="Search in channel"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-4.35-4.35M17 11A6 6 0 1 1 5 11a6 6 0 0 1 12 0z" />
                </svg>
              </button>
            )}
          </>
        )}
      </div>

      {/* Messages */}
      <div
        id="chat-container"
        className="flex-1 overflow-y-auto p-4 flex flex-col gap-1"
      >
        {displayMessages.length === 0 && (
          <div className="text-gray-400">
            {searchQuery.trim() ? "No messages match your search." : "No messages yet"}
          </div>
        )}

        {annotated.map(({ msg, showTime, showDateDivider }) => {
          const isMe = msg.username === user.username;

          return (
            <div key={msg.msgid}>
              {/* Date divider */}
              {showDateDivider && (
                <div className="flex items-center gap-3 my-3">
                  <div className="flex-1 h-px bg-gray-300" />
                  <span className="text-xs text-gray-400 whitespace-nowrap">
                    {formatDateDivider(msg.postat)}
                  </span>
                  <div className="flex-1 h-px bg-gray-300" />
                </div>
              )}

              {/* Message bubble */}
              <div className={`flex ${isMe ? "justify-end" : "justify-start"}`}>
                <div className="flex flex-col">
                  <div
                    className={`max-w-xs px-4 py-2 rounded-2xl shadow
                      ${isMe ? "bg-[#240057] text-white" : "bg-gray-200 text-black"}`}
                  >
                    <div className="text-xs opacity-70 mb-1 font-semibold">{msg.username}</div>
                    <MessageContent content={msg.content} isMe={isMe} />
                  </div>
                  {showTime && (
                    <span className={`text-xs text-gray-400 mt-0.5 ${isMe ? "text-right" : "text-left"}`}>
                      {formatTime(msg.postat)}
                    </span>
                  )}
                </div>
              </div>
            </div>
          );
        })}
        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div
        className="border-t bg-white"
        style={{ display: 'grid', gridTemplateColumns: '1fr auto', alignItems: 'end', gap: '8px', padding: '12px' }}
        ref={inputAreaRef}
      >
        <div style={{ position: 'relative', minWidth: 0 }}>
          <textarea
            ref={textareaRef}
            value={input}
            onChange={handleInputChange}
            onKeyDown={(e) => {
              if (mentionQuery !== null && mentionResults.length > 0) {
                if (e.key === "ArrowDown") {
                  e.preventDefault();
                  setMentionIndex((prev) => Math.min(prev + 1, mentionResults.length - 1));
                  return;
                }
                if (e.key === "ArrowUp") {
                  e.preventDefault();
                  setMentionIndex((prev) => Math.max(prev - 1, 0));
                  return;
                }
                if (e.key === "Tab" || e.key === "Enter") {
                  e.preventDefault();
                  selectMention(mentionResults[mentionIndex]);
                  return;
                }
                if (e.key === "Escape") {
                  setMentionQuery(null);
                  return;
                }
              }
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
              }
            }}
            placeholder="Type a message (@ to mention, Shift+Enter for new line)"
            className="w-full px-3 pr-10 rounded-lg border-2 border-[#240057] focus:outline-none resize-none block"
            style={{ height: "44px", maxHeight: "120px", lineHeight: "24px", paddingTop: "10px", paddingBottom: "10px", overflowY: "hidden" }}
            onInput={(e) => {
              e.target.style.height = "44px";
              e.target.style.height = Math.min(e.target.scrollHeight, 120) + "px";
            }}
          />

          {/* Emoji button inside textarea */}
          <button
            onClick={() => setShowEmojiPicker((prev) => !prev)}
            className="absolute text-gray-400 hover:text-gray-600 text-xl"
            style={{ right: '8px', top: '50%', transform: 'translateY(-50%)' }}
            title="Emoji"
          >
            🙂
          </button>

          {/* Emoji picker */}
          {showEmojiPicker && (
            <div
              className="absolute bottom-full right-0 mb-1 w-80 bg-white border rounded-xl shadow-xl z-50 flex flex-col"
              style={{ maxHeight: "360px" }}
            >
              <div className="flex gap-1 p-2 border-b overflow-x-auto text-sm">
                {Object.keys(EMOJI_CATEGORIES).map((cat) => (
                  <button
                    key={cat}
                    onClick={() => setEmojiCategory(cat)}
                    className={`px-2 py-1 rounded whitespace-nowrap ${
                      emojiCategory === cat ? "bg-[#240057] text-white" : "hover:bg-gray-100"
                    }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>
              <div className="p-2 overflow-y-auto flex-1">
                <div className="grid grid-cols-8 gap-1">
                  {EMOJI_CATEGORIES[emojiCategory].map((emoji) => (
                    <button
                      key={emoji}
                      onClick={() => insertEmoji(emoji)}
                      className="text-2xl p-1 hover:bg-gray-100 rounded cursor-pointer"
                    >
                      {emoji}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* @Mention dropdown */}
          {mentionQuery !== null && mentionResults.length > 0 && (
            <div
              ref={mentionRef}
              className="absolute bottom-full left-0 mb-1 w-72 bg-white border rounded-lg shadow-xl z-50 overflow-hidden"
            >
              <div className="px-3 py-1.5 text-xs text-gray-400 border-b">Members matching @{mentionQuery}</div>
              {mentionResults.map((m, idx) => (
                <div
                  key={m.uid}
                  onClick={() => selectMention(m)}
                  className={`flex items-center gap-2 px-3 py-2 cursor-pointer text-sm ${
                    idx === mentionIndex ? "bg-[#240057] text-white" : "hover:bg-gray-100"
                  }`}
                >
                  <span className="font-medium">@{m.username}</span>
                  {m.nickname && (
                    <span className={`text-xs ${idx === mentionIndex ? "text-white/70" : "text-gray-400"}`}>
                      ({m.nickname})
                    </span>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        <button
          onClick={sendMessage}
          className="px-4 bg-[#240057] text-white rounded-lg hover:opacity-90 shrink-0"
          style={{ height: '44px' }}
        >
          Send
        </button>
      </div>
    </div>
  );
}

export default ChatWindow;
