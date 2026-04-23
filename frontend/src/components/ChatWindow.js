function ChatWindow({ messages, input, setInput, sendMessage, chid }) {
return (
<div style={{ flex: 1 }}> <h2>Channel {chid}</h2>
  {messages.map((msg) => (
    <div key={msg.msgid}>
      <strong>{msg.username}:</strong> {msg.content}
    </div>
  ))}

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
