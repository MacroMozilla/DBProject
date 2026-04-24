import { useState } from "react";
import Modal from "./Modal";
import { apiCall } from "../services/api";

function CreateWorkspaceModal({ onClose, onCreate }) {
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [userInput, setUserInput] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleCreate = async () => {
    const trimmedName = name.trim();
    if (!trimmedName) return;

    setLoading(true);
    setError("");

    // 1. Create the workspace (backend only takes name + description)
    const usernames = userInput
      .split(",")
      .map((u) => u.trim())
      .filter((u) => u.length > 0);

    // onCreate handles the createWorkspace call and refreshes the list
    // We need the wsid back to send invites, so we call the API directly here
    // then let onCreate do its refresh dance
    try {
      const wsResult = await apiCall("create_workspace", [], {
        wsname: trimmedName,
        wsdescription: description.trim(),
      });

      if (wsResult?.error) {
        setError(wsResult.error);
        setLoading(false);
        return;
      }

      const wsid = wsResult.wsid;

      // 2. For each username, look up their uid then send a workspace invite
      const failed = [];
      for (const username of usernames) {
        const users = await apiCall("search_users", [], { query: username });
        // search_users does ILIKE so find an exact username match
        const match = users?.find(
          (u) => u.username.toLowerCase() === username.toLowerCase()
        );
        if (match) {
          await apiCall("invite_to_workspace", [], {
            wsid,
            invitee_uid: match.uid,
          });
        } else {
          failed.push(username);
        }
      }

      if (failed.length > 0) {
        setError(`Workspace created! Could not find: ${failed.join(", ")}`);
        onCreate(); // refresh the list
        setTimeout(onClose, 2500);
      } else {
        onCreate(); // refresh the list
        onClose();
      }
    } catch (e) {
      setError("Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Modal title="Create Workspace" onClose={onClose}>
      <input
        placeholder="Workspace name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        className="w-full mb-3 p-2 border rounded"
      />

      <input
        placeholder="Description (optional)"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        className="w-full mb-3 p-2 border rounded"
      />

      <input
        placeholder="Invite users (comma-separated usernames)"
        value={userInput}
        onChange={(e) => setUserInput(e.target.value)}
        className="w-full mb-1 p-2 border rounded"
      />
      <p className="text-xs text-gray-400 mb-4">
        e.g. bobsmith, carolwang — they'll receive an inbox invite
      </p>

      {error && (
        <p className="text-sm text-red-500 mb-3">{error}</p>
      )}

      <div className="flex justify-end gap-2">
        <button
          onClick={onClose}
          className="px-3 py-1 bg-gray-200 rounded"
          disabled={loading}
        >
          Cancel
        </button>

        <button
          onClick={handleCreate}
          className="px-3 py-1 bg-[#240057] text-white rounded disabled:opacity-50"
          disabled={loading || !name.trim()}
        >
          {loading ? "Creating..." : "Create"}
        </button>
      </div>
    </Modal>
  );
}

export default CreateWorkspaceModal;