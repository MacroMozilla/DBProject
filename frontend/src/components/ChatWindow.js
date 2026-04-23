function ChatWindow({ messages, input, setInput, sendMessage, chid }) {
  // Ensure messages is always an array
  const safeMessages = Array.isArray(messages) ? messages : [];

  return (
    <div style={{ flex: 1 }}>
      <h2>Channel {chid}</h2>

      {safeMessages.length === 0 ? (
        <p>No messages yet</p>
      ) : (
        safeMessages.map((msg) => (
          <div key={msg.msgid}>
            <strong>{msg.username}:</strong> {msg.content}
          </div>
        ))
      )}

      <div style={{ marginTop: "10px" }}>
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Type a message"
        />
        <button onClick={sendMessage}>Send</button>
      </div>
    </div>
  );
}

export default ChatWindow;