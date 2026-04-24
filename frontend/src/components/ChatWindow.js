function ChatWindow({ messages, input, setInput, sendMessage, chid, user, channelName }) {
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
                <div className="text-xs opacity-70 font-semibold mb-1">
                  {msg.username}
                </div>
                {msg.content}
              </div>
            </div>
          );
        })}
      </div>

      {/* Input */}
      <div className="p-3 border-t bg-white flex gap-2">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Type a message"
          className="flex-1 p-3 rounded-lg border-2 border-[#240057] focus:outline-none"
        />

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