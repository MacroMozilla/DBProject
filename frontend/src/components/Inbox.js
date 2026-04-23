function Inbox({ invites, showInbox, setShowInbox, onAccept, onReject }) {
return (
<>
<button
onClick={(e) => {
e.stopPropagation();
setShowInbox(!showInbox);
}}
>
Inbox ({invites.length}) </button>
  {showInbox && (
    <div
      onClick={(e) => e.stopPropagation()}
      style={{
        position: "absolute",
        top: "60px",
        left: "20px",
        background: "white",
        border: "1px solid #ccc",
        padding: "10px",
        width: "250px",
        zIndex: 1000,
      }}
    >
      <h3>Invites</h3>

      {invites.length === 0 && <p>No invites</p>}

      {invites.map((inv) => (
        <div key={inv.wsid}>
          {inv.wsname}
          <br />
          <button onClick={() => onAccept(inv.wsid)}>Accept</button>
          <button onClick={() => onReject(inv.wsid)}>Reject</button>
        </div>
      ))}
    </div>
  )}
</>

);
}

export default Inbox;
