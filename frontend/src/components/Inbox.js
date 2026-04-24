function Inbox({ invites, onAccept, onReject }) {
  return (
    <div
      className="absolute right-0 mt-2 w-72 bg-white text-gray-900 border rounded shadow-lg p-4 z-50"
      onClick={(e) => e.stopPropagation()}
    >
      <h3 className="font-semibold mb-3">Invites</h3>

      {(!invites || invites.length === 0) && (
        <p className="text-gray-500 text-sm">No invites</p>
      )}

      {invites.map((inv) => (
        <div key={inv.id} className="mb-4 border-b pb-2">

          {/* THIS LINE WAS MISSING / BROKEN */}
          <div className="text-sm font-medium mb-2">
            {inv.type === "workspace"
              ? `Workspace: ${inv.name}`
              : `Channel: ${inv.name}`}
          </div>

          <div className="flex gap-2">
            <button
              onClick={() => onAccept(inv.id, inv.type)}
              className="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600"
            >
              Accept
            </button>

            <button
              onClick={() => onReject(inv.id, inv.type)}
              className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
            >
              Reject
            </button>
          </div>
        </div>
      ))}
    </div>
  );
}

export default Inbox;