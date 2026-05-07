function WorkspaceList({ workspaces, wsid, setWsid, onCreateWorkspace }) {
  return (
    <div>
      <div className="flex justify-between items-center mb-3">
        <h3 className="text-sm font-semibold opacity-70">WORKSPACES</h3>

        <button
          onClick={onCreateWorkspace}
          className="w-6 h-6 flex items-center justify-center bg-white/10 rounded hover:bg-white/20"
        >
          +
        </button>
      </div>

      {workspaces.length === 0 && (
        <div className="text-sm opacity-60">No workspaces</div>
      )}

      {workspaces.map((ws) => (
        <div
          key={ws.wsid}
          onClick={() => setWsid(ws.wsid)}
          className={`p-2 rounded cursor-pointer ${
            wsid === ws.wsid ? "bg-white/20" : "hover:bg-white/10"
          }`}
        >
          {ws.wsname}
        </div>
      ))}
    </div>
  );
}

export default WorkspaceList;