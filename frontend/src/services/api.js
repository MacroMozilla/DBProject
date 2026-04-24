const BASE_URL = "http://localhost:8000/api/core";

/**
 * Core RPC helper
 */
export const apiCall = async (func, args = [], kwargs = {}) => {
  const res = await fetch(BASE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify({
      function: func,
      args,
      kwargs,
    }),
  });

  const data = await res.json();
  console.log("API RAW RESPONSE:", data);

  if (!data.ok) {
    console.error("API ERROR:", data);
    throw new Error(data.error || "API error");
  }

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

export const fetchWorkspaceMembers = (wsid) =>
  apiCall("get_workspace_members", [wsid]);

export const inviteToWorkspace = (wsid, invitee_uid) =>
  apiCall("invite_to_workspace", [wsid, invitee_uid]);

export const updateWorkspaceMember = (wsid, target_uid, options = {}) =>
  apiCall("update_workspace_member", [wsid, target_uid], options);

export const leaveWorkspace = (wsid) =>
  apiCall("leave_workspace", [wsid]);

export const deleteWorkspace = (wsid) =>
  apiCall("delete_workspace", [wsid]);



// ================= CHANNELS =================

export const fetchChannels = (wsid) =>
  apiCall("get_channels", [wsid]);

export const createChannel = (wsid, chname, chtype = "public") =>
  apiCall("create_channel", [wsid, chname, chtype]);

export const inviteToChannel = (chid, invitee_uid) =>
  apiCall("invite_to_channel", [chid, invitee_uid]);

export const fetchChannelMembers = (chid) =>
  apiCall("get_channel_members", [chid]);

export const joinChannel = (chid) =>
  apiCall("join_channel", [chid]);

export const leaveChannel = (chid) =>
  apiCall("leave_channel", [chid]);

export const deleteChannel = (chid) =>
  apiCall("delete_channel", [chid]);

export const fetchPublicChannels = (wsid) =>
  apiCall("get_public_channels", [wsid]);

export const markChannelRead = (chid) =>
  apiCall("mark_channel_read", [chid]);



// ================= MESSAGES =================

export const fetchMessages = (chid) =>
  apiCall("get_messages", [chid]);

export const sendMessage = (chid, content) =>
  apiCall("send_message", [chid, content]);

export const searchMessages = (keyword) =>
  apiCall("search_messages", [keyword]);



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



// ================= USERS =================

export const searchUsers = (query) =>
  apiCall("search_users", [query]);

// ================= UTIL =================

export const refreshAll = async () => {
  const [workspaces, invites] = await Promise.all([
    fetchWorkspaces(),
    fetchInvites(),
  ]);
  return { workspaces, invites };
};
