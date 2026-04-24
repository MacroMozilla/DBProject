import { useEffect, useState, useCallback } from "react";
import Modal from "./Modal";
import {
  fetchChannelMembers,
  fetchWorkspaceMembers,
  inviteToChannel,
  leaveChannel,
  deleteChannel,
} from "../services/api";

function ChannelSettingsModal({ chid, wsid, currentUser, onClose, onDeleted, onLeft }) {
  const [channelMembers, setChannelMembers] = useState([]);
  const [wsMembers, setWsMembers] = useState([]);
  const [myRole, setMyRole] = useState(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const loadData = useCallback(async () => {
    const [chMembers, wsAll] = await Promise.all([
      fetchChannelMembers(chid),
      fetchWorkspaceMembers(wsid),
    ]);
    setChannelMembers(chMembers || []);
    setWsMembers(wsAll || []);
    const me = chMembers?.find((m) => m.uid === currentUser.uid);
    setMyRole(me?.role || "member");
  }, [chid, wsid, currentUser.uid]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const isCreator = myRole === "creator";

  const invitable = wsMembers.filter(
    (wm) =>
      wm.status === "accepted" &&
      !channelMembers.some((cm) => cm.uid === wm.uid)
  );

  const handleInvite = async (uid) => {
    setError("");
    try {
      await inviteToChannel(chid, uid);
      loadData();
    } catch (e) {
      setError(e.message);
    }
  };

  const handleLeave = async () => {
    if (!window.confirm("Leave this channel?")) return;
    setLoading(true);
    try {
      await leaveChannel(chid);
      onLeft();
      onClose();
    } catch (e) {
      setError(e.message);
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Delete this channel and all its messages? This cannot be undone.")) return;
    setLoading(true);
    try {
      await deleteChannel(chid);
      onDeleted();
      onClose();
    } catch (e) {
      setError(e.message);
      setLoading(false);
    }
  };

  return (
    <Modal title="Channel Settings" onClose={onClose}>
      <div className="text-sm font-semibold mb-2">Members</div>
      <div className="max-h-40 overflow-y-auto border rounded divide-y mb-4">
        {channelMembers
          .filter((m) => m.status === "accepted")
          .map((m) => (
            <div key={m.uid} className="flex items-center justify-between px-3 py-2 text-sm">
              <span>{m.username}</span>
              {m.role === "creator" && (
                <span className="text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full">creator</span>
              )}
            </div>
          ))}
      </div>

      {isCreator && invitable.length > 0 && (
        <>
          <div className="text-sm font-semibold mb-2">Add members</div>
          <div className="max-h-40 overflow-y-auto border rounded divide-y mb-4">
            {invitable.map((m) => (
              <div key={m.uid} className="flex items-center justify-between px-3 py-2 text-sm hover:bg-gray-50">
                <span>{m.username}</span>
                <button onClick={() => handleInvite(m.uid)} className="text-xs text-[#240057] hover:underline">
                  Invite
                </button>
              </div>
            ))}
          </div>
        </>
      )}

      {error && <p className="text-sm text-red-500 mb-3">{error}</p>}

      <div className="flex justify-between items-center">
        <div className="flex gap-2">
          <button
            onClick={handleLeave}
            disabled={loading}
            className="px-3 py-1 text-sm bg-red-100 text-red-600 rounded hover:bg-red-200 disabled:opacity-50"
          >
            Leave channel
          </button>
          {isCreator && (
            <button
              onClick={handleDelete}
              disabled={loading}
              className="px-3 py-1 text-sm bg-red-500 text-white rounded hover:bg-red-600 disabled:opacity-50"
            >
              Delete channel
            </button>
          )}
        </div>
        <button onClick={onClose} className="px-3 py-1 bg-gray-200 rounded text-sm">
          Close
        </button>
      </div>
    </Modal>
  );
}

export default ChannelSettingsModal;