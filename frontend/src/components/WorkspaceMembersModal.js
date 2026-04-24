import { useEffect, useState, useCallback } from "react";
import Modal from "./Modal";
import {
  fetchWorkspaceMembers,
  inviteToWorkspace,
  updateWorkspaceMember,
  leaveWorkspace,
  deleteWorkspace,
  searchUsers,
} from "../services/api";

function WorkspaceMembersModal({ wsid, currentUser, onClose, onLeft, onDeleted }) {
  const [members, setMembers] = useState([]);
  const [myRole, setMyRole] = useState(null);
  const [inviteInput, setInviteInput] = useState("");
  const [inviteError, setInviteError] = useState("");
  const [inviteSuccess, setInviteSuccess] = useState("");
  const [loading, setLoading] = useState(false);

  const loadMembers = useCallback(async () => {
    const data = await fetchWorkspaceMembers(wsid);
    setMembers(data || []);
    const me = data?.find((m) => m.uid === currentUser.uid);
    setMyRole(me?.role || null);
  }, [wsid, currentUser.uid]);

  useEffect(() => {
    loadMembers();
  }, [loadMembers]);

  const isAdmin = myRole === "creator" || myRole === "admin";

  const handleInvite = async () => {
    const username = inviteInput.trim();
    if (!username) return;
    setInviteError("");
    setInviteSuccess("");
    setLoading(true);
    try {
      const users = await searchUsers(username);
      const match = users?.find((u) => u.username.toLowerCase() === username.toLowerCase());
      if (!match) {
        setInviteError(`User "${username}" not found.`);
        return;
      }
      await inviteToWorkspace(wsid, match.uid);
      setInviteSuccess(`Invite sent to ${match.username}.`);
      setInviteInput("");
      loadMembers();
    } catch (e) {
      setInviteError(e.message || "Failed to invite user.");
    } finally {
      setLoading(false);
    }
  };

  const handleRemove = async (uid) => {
    if (!window.confirm("Remove this member from the workspace?")) return;
    await updateWorkspaceMember(wsid, uid, { remove: true });
    loadMembers();
  };

  const handleRoleToggle = async (uid, currentRole) => {
    const newRole = currentRole === "admin" ? "member" : "admin";
    await updateWorkspaceMember(wsid, uid, { role: newRole });
    loadMembers();
  };

  const handleLeave = async () => {
    if (!window.confirm("Leave this workspace? You will lose access to all its channels.")) return;
    try {
      await leaveWorkspace(wsid);
      onLeft();
      onClose();
    } catch (e) {
      alert(e.message);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Permanently delete this workspace and ALL its channels and messages? This cannot be undone.")) return;
    try {
      await deleteWorkspace(wsid);
      onDeleted();
      onClose();
    } catch (e) {
      alert(e.message);
    }
  };

  const roleLabel = (role) => {
    if (role === "creator") return <span className="text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full">creator</span>;
    if (role === "admin") return <span className="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full">admin</span>;
    return <span className="text-xs bg-gray-100 text-gray-500 px-2 py-0.5 rounded-full">member</span>;
  };

  return (
    <Modal title="Workspace Members" onClose={onClose}>
      {isAdmin && (
        <div className="mb-4">
          <div className="text-sm font-semibold mb-1">Invite a user</div>
          <div className="flex gap-2">
            <input
              placeholder="Username"
              value={inviteInput}
              onChange={(e) => setInviteInput(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleInvite()}
              className="flex-1 p-2 border rounded text-sm"
            />
            <button
              onClick={handleInvite}
              disabled={loading}
              className="px-3 py-1 bg-[#240057] text-white rounded text-sm disabled:opacity-50"
            >
              Invite
            </button>
          </div>
          {inviteError && <p className="text-xs text-red-500 mt-1">{inviteError}</p>}
          {inviteSuccess && <p className="text-xs text-green-600 mt-1">{inviteSuccess}</p>}
        </div>
      )}

      <div className="text-sm font-semibold mb-2">
        Members ({members.filter(m => m.status === "accepted").length})
      </div>
      <div className="max-h-56 overflow-y-auto border rounded divide-y mb-4">
        {members
          .filter((m) => m.status === "accepted")
          .map((m) => (
            <div key={m.uid} className="flex items-center justify-between px-3 py-2 hover:bg-gray-50">
              <div className="flex items-center gap-2">
                <span className="text-sm font-medium">{m.username}</span>
                {roleLabel(m.role)}
              </div>
              {isAdmin && m.uid !== currentUser.uid && m.role !== "creator" && (
                <div className="flex gap-2">
                  <button onClick={() => handleRoleToggle(m.uid, m.role)} className="text-xs text-blue-600 hover:underline">
                    {m.role === "admin" ? "Demote" : "Make admin"}
                  </button>
                  <button onClick={() => handleRemove(m.uid)} className="text-xs text-red-500 hover:underline">
                    Remove
                  </button>
                </div>
              )}
            </div>
          ))}
      </div>

      {members.some((m) => m.status === "pending") && (
        <>
          <div className="text-sm font-semibold mb-2 text-gray-500">Pending invites</div>
          <div className="max-h-32 overflow-y-auto border rounded divide-y mb-4">
            {members
              .filter((m) => m.status === "pending")
              .map((m) => (
                <div key={m.uid} className="flex items-center justify-between px-3 py-2 text-sm text-gray-500">
                  <span>{m.username}</span>
                  <span className="text-xs italic">awaiting response</span>
                </div>
              ))}
          </div>
        </>
      )}

      <div className="flex justify-between items-center">
        <div className="flex gap-2">
          {/* Non-creators can leave */}
          {myRole !== "creator" && (
            <button onClick={handleLeave} className="px-3 py-1 text-sm bg-red-100 text-red-600 rounded hover:bg-red-200">
              Leave workspace
            </button>
          )}
          {/* Creators can delete */}
          {myRole === "creator" && (
            <button onClick={handleDelete} className="px-3 py-1 text-sm bg-red-500 text-white rounded hover:bg-red-600">
              Delete workspace
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

export default WorkspaceMembersModal;