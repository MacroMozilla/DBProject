function ChannelList({ channels, chid, setChid }) {
  // Make sure channels is always an array
  const safeChannels = Array.isArray(channels) ? channels : [];

  return (
    <div style={{ width: "200px", marginRight: "20px" }}>
      <h3>Channels</h3>

      {safeChannels.length === 0 ? (
        <p>No channels</p>
      ) : (
        safeChannels.map((ch) => (
          <div
            key={ch.chid}
            onClick={() => setChid(ch.chid)}
            style={{
              cursor: "pointer",
              padding: "5px",
              background: chid === ch.chid ? "#ddd" : "transparent",
            }}
          >
            #{ch.chname || "DM"}
          </div>
        ))
      )}
    </div>
  );
}

export default ChannelList;