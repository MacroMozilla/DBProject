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

      {channels.map((ch) => {
        const isActive = chid === ch.chid;
        const hasUnread = !isActive && ch.unread_count > 0;

        return (
          <div
            key={ch.chid}
            onClick={() => setChid(ch.chid)}
            className={`flex items-center justify-between p-2 rounded cursor-pointer ${
              isActive ? "bg-gray-300" : "hover:bg-gray-200"
            }`}
          >
            <span className={`truncate text-sm ${hasUnread ? "font-semibold text-gray-900" : "text-gray-700"}`}>
              # {ch.chname || "DM"}
            </span>

            {hasUnread && (
              <span className="ml-2 min-w-[20px] h-5 flex items-center justify-center rounded-full bg-[#240057] text-white text-xs px-1.5">
                {ch.unread_count > 99 ? "99+" : ch.unread_count}
              </span>
            )}
          </div>
        );
      })}
    </div>
  );
}

export default ChannelList;