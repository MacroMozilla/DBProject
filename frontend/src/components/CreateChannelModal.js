import { useEffect, useState } from "react";
import Modal from "./Modal";
import { fetchWorkspaceMembers, inviteToChannel } from "../services/api";

function CreateChannelModal({ wsid, onClose, onCreate }) {
  const [name, setName] = useState("");
  const [type, setType] = useState("public");
  const [members, setMembers] = useState([]);
  const [selected, setSelected] = useState([]);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (wsid) {
      fetchWorkspaceMembers(wsid).then((data) => setMembers(data || []));
    }
  }, [wsid]);

  const handleTypeChange = (newType) => {
    setType(newType);
    setSelected([]);
    setError("");
  };

  const toggleUser = (uid) => {
    if (type === "direct") {
      setSelected((prev) => (prev.includes(uid) ? [] : [uid]));
    } else {
      setSelected((prev) =>
        prev.includes(uid) ? prev.filter((id) => id !== uid) : [...prev, uid]
      );
    }
  };

  const handleSubmit = async () => {
    setError("");

    if (type !== "direct" && !name.trim()) {
      setError("Channel name is required.");
      return;
    }
    if (type === "direct" && selected.length !== 1) {
      setError("Select exactly one user for a direct message.");
      return;
    }

    setLoading(true);
    try {
      // For DMs, autopopulate the channel name as "DM - username"
      let channelName = name.trim();
      if (type === "direct") {
        const otherUser = members.find((m) => m.uid === selected[0]);
        channelName = `DM - ${otherUser?.username || selected[0]}`;
      }

      const channel = await onCreate(channelName, type);

      if (!channel || channel.error) {
        setError(channel?.error || "Failed to create channel.");
        setLoading(false);
        return;
      }

      // Invite selected users for private + direct
      if (type !== "public") {
        for (const uid of selected) {
          await inviteToChannel(channel.chid, uid);
        }
      }

      onClose();
    } catch (e) {
      setError("Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const typeDescriptions = {
    public: "Anyone in the workspace can join and read messages.",
    private: "Only invited workspace members can join.",
    direct: "A private conversation between you and one other person.",
  };

  return (
    <Modal title="Create Channel" onClose={onClose}>
      {type !== "direct" && (
        <input
          placeholder="Channel name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          className="w-full mb-3 p-2 border rounded"
        />
      )}

      <select
        value={type}
        onChange={(e) => handleTypeChange(e.target.value)}
        className="w-full mb-1 p-2 border rounded"
      >
        <option value="public">Public</option>
        <option value="private">Private</option>
        <option value="direct">Direct Message</option>
      </select>
      <p className="text-xs text-gray-400 mb-3">{typeDescriptions[type]}</p>

      {type !== "public" && (
        <div className="mb-4">
          <div className="text-sm font-semibold mb-2">
            {type === "direct" ? "Select a user" : "Invite members (optional)"}
          </div>
          <div className="max-h-40 overflow-y-auto border rounded p-2">
            {members.length === 0 && (
              <p className="text-xs text-gray-400">No other members in this workspace yet.</p>
            )}
            {members.map((m) => (
              <label key={m.uid} className="flex items-center gap-2 text-sm py-1 cursor-pointer hover:bg-gray-50 rounded px-1">
                <input
                  type={type === "direct" ? "radio" : "checkbox"}
                  checked={selected.includes(m.uid)}
                  onChange={() => toggleUser(m.uid)}
                />
                <span>{m.username}</span>
                {m.nickname && <span className="text-gray-400 text-xs">({m.nickname})</span>}
              </label>
            ))}
          </div>
        </div>
      )}

      {error && <p className="text-sm text-red-500 mb-3">{error}</p>}

      <div className="flex justify-end gap-2">
        <button onClick={onClose} className="px-3 py-1 bg-gray-200 rounded" disabled={loading}>
          Cancel
        </button>
        <button
          onClick={handleSubmit}
          className="px-3 py-1 bg-[#240057] text-white rounded disabled:opacity-50"
          disabled={loading}
        >
          {loading ? "Creating..." : "Create"}
        </button>
      </div>
    </Modal>
  );
}

export default CreateChannelModal;