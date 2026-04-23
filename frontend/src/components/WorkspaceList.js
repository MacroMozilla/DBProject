function WorkspaceList({ workspaces, wsid, setWsid }) {
return (
<div style={{ width: "150px", marginRight: "20px" }}> <h3>Workspaces</h3>
{workspaces.map((ws) => (
<div
key={ws.wsid}
onClick={() => setWsid(ws.wsid)}
style={{
cursor: "pointer",
padding: "5px",
background: wsid === ws.wsid ? "#ccc" : "transparent",
}}
>
{ws.wsname} </div>
))} </div>
);
}

export default WorkspaceList;
