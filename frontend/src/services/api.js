const BASE_URL = "http://localhost:8000";

export const fetchWorkspaces = async (uid) => {
const res = await fetch(`${BASE_URL}/workspaces/?uid=${uid}`);
return res.json();
};

export const fetchChannels = async (wsid) => {
const res = await fetch(`${BASE_URL}/channels/?wsid=${wsid}`);
return res.json();
};

export const fetchMessages = async (chid) => {
const res = await fetch(`${BASE_URL}/messages/?chid=${chid}`);
return res.json();
};

export const fetchInvites = async (uid) => {
const res = await fetch(`${BASE_URL}/invites/?uid=${uid}`);
return res.json();
};

export const sendMessage = async (chid, uid, content) => {
await fetch(`${BASE_URL}/send-message/`, {
method: "POST",
headers: {"Content-Type": "application/json"},
body: JSON.stringify({ chid, uid, content }),
});
};

export const acceptInvite = async (wsid, uid) => {
await fetch(`${BASE_URL}/accept-invite/`, {
method: "POST",
headers: {"Content-Type": "application/json"},
body: JSON.stringify({ wsid, uid }),
});
};

export const rejectInvite = async (wsid, uid) => {
await fetch(`${BASE_URL}/reject-invite/`, {
method: "POST",
headers: {"Content-Type": "application/json"},
body: JSON.stringify({ wsid, uid }),
});
};
