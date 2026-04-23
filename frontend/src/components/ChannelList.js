function ChannelList({ channels, chid, setChid }) {
return (
<div style={{ width: "200px", marginRight: "20px" }}> <h3>Channels</h3>
{channels.map((ch) => (
<div
key={ch.chid}
onClick={() => setChid(ch.chid)}
style={{
cursor: "pointer",
padding: "5px",
background: chid === ch.chid ? "#ddd" : "transparent",
}}
>
#{ch.chname} </div>
))} </div>
);
}

export default ChannelList;
