function ChannelList({ channels, chid, setChid, onCreateChannel }) {
  return (
    <div>
      <div className="flex justify-between items-center mb-3">
        <h3 className="text-sm font-semibold opacity-70">CHANNELS</h3>

        <button
          onClick={onCreateChannel}
          className="bg-gray-300 px-2 rounded hover:bg-gray-400"
        >
          +
        </button>
      </div>

      {channels.length === 0 && (
        <div className="text-sm text-gray-500">No channels</div>
      )}

      {channels.map((ch) => (
        <div
          key={ch.chid}
          onClick={() => setChid(ch.chid)}
          className={`p-2 rounded cursor-pointer ${
            chid === ch.chid ? "bg-gray-300" : "hover:bg-gray-200"
          }`}
        >
          # {ch.chname || "DM"}
        </div>
      ))}
    </div>
  );
}

export default ChannelList;