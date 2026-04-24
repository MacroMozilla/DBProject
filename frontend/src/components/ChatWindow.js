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

// Convert bare image URLs to markdown image syntax and highlight @mentions
function preprocessContent(content) {
  let processed = content.replace(IMAGE_URL_REGEX, (url) => {
    const idx = content.indexOf(url);
    if (idx > 0 && (content[idx - 1] === "(" || content[idx - 2] === "]")) return url;
    return `\n![](${url})\n`;
  });
  // Bold @mentions so they stand out
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
        // Render images inline with size limit
        img: ({ src, alt }) => (
          <img
            src={src}
            alt={alt || "shared"}
            className="max-w-full rounded-lg mt-1"
            style={{ maxHeight: "200px" }}
            onError={(e) => { e.target.style.display = "none"; }}
          />
        ),
        // Keep paragraphs compact in chat bubbles
        p: ({ children }) => <p className="my-0.5">{children}</p>,
        // Style inline code (code blocks are wrapped in <pre> by markdown)
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
        // Style links
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

function ChatWindow({ messages, input, setInput, sendMessage, chid, user, channelName, channelMembers = [] }) {
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [emojiCategory, setEmojiCategory] = useState("Smileys");
  const [mentionQuery, setMentionQuery] = useState(null); // null = hidden, string = filter
  const [mentionIndex, setMentionIndex] = useState(0);

  const pickerRef = useRef(null);
  const textareaRef = useRef(null);
  const mentionRef = useRef(null);

  // Filtered members for @mention dropdown
  const mentionResults = mentionQuery !== null
    ? channelMembers
        .filter((m) => m.status === "accepted")
        .filter((m) =>
          m.username.toLowerCase().includes(mentionQuery.toLowerCase()) ||
          (m.nickname && m.nickname.toLowerCase().includes(mentionQuery.toLowerCase()))
        )
        .slice(0, 8)
    : [];

  // Close emoji picker on outside click
  useEffect(() => {
    function handleClickOutside(e) {
      if (pickerRef.current && !pickerRef.current.contains(e.target)) {
        setShowEmojiPicker(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const insertEmoji = (emoji) => {
    setInput((prev) => prev + emoji);
  };

  // Extract @mention query from current cursor position
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

  // Insert selected mention into input
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

    // Restore cursor position after React re-render
    const newCursorPos = beforeMention.length + 1 + member.username.length + 1;
    setTimeout(() => {
      textarea.focus();
      textarea.setSelectionRange(newCursorPos, newCursorPos);
    }, 0);
  };

  return (
    <div className="flex flex-col h-full bg-gray-100">

      {/* Header */}
      <div className="px-4 py-3 border-b bg-white font-semibold">
        {channelName ? `#${channelName}` : "Select a channel"}
      </div>

      {/* Messages */}
      <div
        id="chat-container"
        className="flex-1 overflow-y-auto p-4 flex flex-col gap-3"
      >
        {messages.length === 0 && (
          <div className="text-gray-400">No messages yet</div>
        )}

        {messages.map((msg) => {
          const isMe = msg.username === user.username;

          return (
            <div
              key={msg.msgid}
              className={`flex ${isMe ? "justify-end" : "justify-start"}`}
            >
              <div
                className={`max-w-xs px-4 py-2 rounded-2xl shadow
                  ${isMe ? "bg-[#240057] text-white" : "bg-gray-200 text-black"}`}
              >
                <div className="flex justify-between items-center text-xs opacity-70 mb-1">
                  <span className="font-semibold">{msg.username}</span>
                  <span className="ml-2">{msg.postat?.replace("T", " ")}</span>
                </div>
                <MessageContent content={msg.content} isMe={isMe} />
              </div>
            </div>
          );
        })}
      </div>

      {/* Input */}
      <div className="p-3 border-t bg-white flex gap-2 relative">
        <div className="flex-1 relative">
          <textarea
            ref={textareaRef}
            value={input}
            onChange={handleInputChange}
            onKeyDown={(e) => {
              // Mention dropdown keyboard navigation
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
            rows={1}
            className="w-full p-3 rounded-lg border-2 border-[#240057] focus:outline-none resize-none"
            style={{ minHeight: "44px", maxHeight: "120px" }}
            onInput={(e) => {
              e.target.style.height = "44px";
              e.target.style.height = Math.min(e.target.scrollHeight, 120) + "px";
            }}
          />

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

        {/* Emoji Picker */}
        <div className="relative" ref={pickerRef}>
          <button
            onClick={() => setShowEmojiPicker((prev) => !prev)}
            className="px-3 py-2 bg-gray-200 rounded-lg hover:bg-gray-300 text-xl"
            title="Emoji"
          >
            😀
          </button>

          {showEmojiPicker && (
            <div className="absolute bottom-12 right-0 w-80 bg-white border rounded-xl shadow-xl z-50 flex flex-col"
                 style={{ maxHeight: "360px" }}>
              {/* Category tabs */}
              <div className="flex gap-1 p-2 border-b overflow-x-auto text-sm">
                {Object.keys(EMOJI_CATEGORIES).map((cat) => (
                  <button
                    key={cat}
                    onClick={() => setEmojiCategory(cat)}
                    className={`px-2 py-1 rounded whitespace-nowrap ${
                      emojiCategory === cat
                        ? "bg-[#240057] text-white"
                        : "hover:bg-gray-100"
                    }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>

              {/* Emoji grid */}
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
        </div>

        <button
          onClick={sendMessage}
          className="px-4 py-2 bg-[#240057] text-white rounded-lg hover:opacity-90"
        >
          Send
        </button>
      </div>
    </div>
  );
}

export default ChatWindow;
