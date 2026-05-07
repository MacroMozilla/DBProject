function ChannelList({ channels, chid, setChid, onCreateChannel, onCreateDM, onBrowse }) {
  const regular = channels.filter((c) => c.chtype !== "direct");
  const dms = channels.filter((c) => c.chtype === "direct");

  const renderItem = (ch, label) => {
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
          {label}
        </span>
        {hasUnread && (
          <span className="ml-2 min-w-[20px] h-5 flex items-center justify-center rounded-full bg-[#240057] text-white text-xs px-1.5">
            {ch.unread_count > 99 ? "99+" : ch.unread_count}
          </span>
        )}
      </div>
    );
  };

  return (
    <div>
      {/* Channels section */}
      <div className="flex justify-between items-center mb-2">
        <h3 className="text-sm font-semibold opacity-70">CHANNELS</h3>
        <button
          onClick={onCreateChannel}
          className="w-6 h-6 flex items-center justify-center bg-gray-300 rounded hover:bg-gray-400"
        >
          +
        </button>
      </div>
      {regular.length === 0 && (
        <div className="text-sm text-gray-500 mb-3">No channels</div>
      )}
      <div className="mb-2">
        {regular.map((ch) => renderItem(ch, `# ${ch.chname || "channel"}`))}
      </div>
      {onBrowse && (
        <button
          onClick={onBrowse}
          className="mb-4 text-xs text-gray-400 hover:text-gray-700 flex items-center gap-1"
        >
          🔍 Browse public channels
        </button>
      )}

      {/* Divider */}
      <div className="border-t border-gray-300 mb-3" />

      {/* Direct Messages section */}
      <div className="flex justify-between items-center mb-2">
        <h3 className="text-sm font-semibold opacity-70">DIRECT MESSAGES</h3>
        <button
          onClick={onCreateDM}
          className="w-6 h-6 flex items-center justify-center bg-gray-300 rounded hover:bg-gray-400"
        >
          +
        </button>
      </div>
      {dms.length === 0 && (
        <div className="text-sm text-gray-500">No direct messages</div>
      )}
      {dms.map((ch) => renderItem(ch, ch.chname || "Unknown"))}
    </div>
  );
}

export default ChannelList;
