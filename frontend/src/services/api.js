const BASE_URL = "http://localhost:8000/api/core";

/**
 * Core RPC helper
 */
export const apiCall = async (func, args = [], kwargs = {}) => {
  const res = await fetch(BASE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include", // required for session auth
    body: JSON.stringify({
      function: func,
      args,
      kwargs,
    }),
  });

  const data = await res.json();
  console.log("API RAW RESPONSE:", data);

  // top-level failure
  if (!data.ok) {
    console.error("API ERROR:", data);
    throw new Error(data.error || "API error");
  }

  // function-level failure
  if (data.data?.error) {
    console.error("API FUNCTION ERROR:", data.data);
    throw new Error(data.data.error);
  }

  return data.data;
};



// ================= AUTH =================

export const login = (username, password) =>
  apiCall("login", [], { username, password });

export const register = (email, username, nickname, password) =>
  apiCall("register", [], { email, username, nickname, password });

export const logout = () =>
  apiCall("logout");

export const me = () =>
  apiCall("me");



// ================= WORKSPACES =================

export const fetchWorkspaces = () =>
  apiCall("get_workspaces");

export const createWorkspace = (wsname, wsdescription = "") =>
  apiCall("create_workspace", [wsname, wsdescription]);

export const inviteToWorkspace = (wsid, invitee_uid) =>
  apiCall("invite_to_workspace", [wsid, invitee_uid]);

export const fetchWorkspaceMembers = (wsid) =>
  apiCall("get_workspace_members", [wsid]);



// ================= CHANNELS =================

export const fetchChannels = (wsid) =>
  apiCall("get_channels", [wsid]);

export const createChannel = (wsid, chname, chtype = "public") =>
  apiCall("create_channel", [wsid, chname, chtype]);

export const inviteToChannel = (chid, invitee_uid) =>
  apiCall("invite_to_channel", [chid, invitee_uid]);



// ================= MESSAGES =================

export const fetchMessages = (chid) =>
  apiCall("get_messages", [chid]);

export const sendMessage = (chid, content) =>
  apiCall("send_message", [chid, content]);



// ================= INVITES =================

export const fetchInvites = () =>
  apiCall("get_invitations");

export const acceptInvite = (id, type) =>
  type === "workspace"
    ? apiCall("respond_workspace_invite", [id, true])
    : apiCall("respond_channel_invite", [id, true]);

export const rejectInvite = (id, type) =>
  type === "workspace"
    ? apiCall("respond_workspace_invite", [id, false])
    : apiCall("respond_channel_invite", [id, false]);



// ================= USERS (FOR SEARCH / PICKERS) =================

// You may need to add this RPC if not already implemented
export const searchUsers = (query) =>
  apiCall("search_users", [query]);



// ================= UTIL (OPTIONAL CLEANUP HELPERS) =================

export const refreshAll = async () => {
  const [workspaces, invites] = await Promise.all([
    fetchWorkspaces(),
    fetchInvites(),
  ]);

  return { workspaces, invites };
};