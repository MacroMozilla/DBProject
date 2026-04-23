function Inbox({ invites, showInbox, setShowInbox, onAccept, onReject }) {
return (
<>
<button
onClick={(e) => {
e.stopPropagation();
setShowInbox(!showInbox);
}}
>
Inbox ({invites?.length || 0}) </button>
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
        borderRadius: "6px",
        boxShadow: "0 2px 8px rgba(0,0,0,0.2)"
      }}
    >
      <h3>Invites</h3>

      {(invites?.length || 0) === 0 && <p>No invites</p>}

      {(invites || []).map((inv) => (
        <div key={inv.id} style={{ marginBottom: "12px" }}>
          <strong>{inv.type}</strong>: {inv.name}

          <div style={{ marginTop: "5px" }}>
            <button onClick={() => onAccept(inv.id, inv.type)}>
              Accept
            </button>

            <button
              onClick={() => onReject(inv.id, inv.type)}
              style={{ marginLeft: "6px" }}
            >
              Reject
            </button>
          </div>
        </div>
      ))}
    </div>
  )}
</>
);
}

export default Inbox;
