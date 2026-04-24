import { useEffect, useState, useCallback } from "react";
import Modal from "./Modal";
import { fetchPublicChannels, joinChannel } from "../services/api";

function DiscoverChannelsModal({ wsid, onClose, onJoined }) {
  const [channels, setChannels] = useState([]);
  const [joining, setJoining] = useState(null);
  const [error, setError] = useState("");

  const load = useCallback(async () => {
    const data = await fetchPublicChannels(wsid);
    setChannels(data || []);
  }, [wsid]);

  useEffect(() => {
    load();
  }, [load]);

  const handleJoin = async (chid) => {
    setJoining(chid);
    setError("");
    try {
      await joinChannel(chid);
      onJoined();
      load();
    } catch (e) {
      setError(e.message);
    } finally {
      setJoining(null);
    }
  };

  return (
    <Modal title="Discover Channels" onClose={onClose}>
      <p className="text-xs text-gray-400 mb-3">
        Public channels in this workspace you haven't joined yet.
      </p>

      {channels.length === 0 ? (
        <p className="text-sm text-gray-500 text-center py-6">
          You're already in all public channels!
        </p>
      ) : (
        <div className="max-h-72 overflow-y-auto border rounded divide-y mb-4">
          {channels.map((ch) => (
            <div key={ch.chid} className="flex items-center justify-between px-3 py-3 hover:bg-gray-50">
              <div>
                <div className="text-sm font-medium"># {ch.chname}</div>
                <div className="text-xs text-gray-400">
                  {ch.member_count} member{ch.member_count !== 1 ? "s" : ""}
                </div>
              </div>
              <button
                onClick={() => handleJoin(ch.chid)}
                disabled={joining === ch.chid}
                className="px-3 py-1 text-sm bg-[#240057] text-white rounded hover:opacity-90 disabled:opacity-50"
              >
                {joining === ch.chid ? "Joining..." : "Join"}
              </button>
            </div>
          ))}
        </div>
      )}

      {error && <p className="text-sm text-red-500 mb-3">{error}</p>}

      <div className="flex justify-end">
        <button onClick={onClose} className="px-3 py-1 bg-gray-200 rounded text-sm">
          Close
        </button>
      </div>
    </Modal>
  );
}

export default DiscoverChannelsModal;