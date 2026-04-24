import { useState, useRef, useEffect } from "react";

const EMOJI_CATEGORIES = {
  "Smileys": ["😀","😂","🤣","😊","😍","🥰","😘","😎","🤩","🥳","😏","😢","😭","😤","🤯","🫠","🤔","🫡","🤗","🫣","😴","🥱","😈","💀","👻","🤖"],
  "Gestures": ["👍","👎","👏","🙌","🤝","✌️","🤞","🫶","💪","👋","🫵","☝️","👆","👇","👈","👉","🖐️","✋","🤙","🤟"],
  "Hearts": ["❤️","🧡","💛","💚","💙","💜","🖤","🤍","💔","❤️‍🔥","💕","💖","💗","💘","💝"],
  "Objects": ["🔥","⭐","🎉","🎊","💯","✅","❌","⚡","💡","📌","📎","🔗","🔑","🏆","🎯","📊","💻","📱","⏰","📝"],
  "Food": ["🍕","🍔","🍟","🌮","🍣","🍜","🍩","🍪","☕","🍺","🧋","🍷","🥤","🧁","🎂"],
  "Animals": ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🦁","🐮","🐷","🐸","🐵","🦄","🐝","🦋"],
  "Nature": ["🌈","☀️","🌙","⭐","🌍","🌸","🌺","🍀","🌴","🌊","❄️","🔥","💧","🌪️"],
};

function ChatWindow({ messages, input, setInput, sendMessage, chid, user, channelName }) {
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [emojiCategory, setEmojiCategory] = useState("Smileys");
  const pickerRef = useRef(null);

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
                {msg.content}
              </div>
            </div>
          );
        })}
      </div>

      {/* Input */}
      <div className="p-3 border-t bg-white flex gap-2 relative">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => { if (e.key === "Enter") sendMessage(); }}
          placeholder="Type a message"
          className="flex-1 p-3 rounded-lg border-2 border-[#240057] focus:outline-none"
        />

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