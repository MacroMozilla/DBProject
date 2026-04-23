import { useEffect, useState } from "react";
import Inbox from "./components/Inbox";
import WorkspaceList from "./components/WorkspaceList";
import ChannelList from "./components/ChannelList";
import ChatWindow from "./components/ChatWindow";

import {
fetchWorkspaces,
fetchChannels,
fetchMessages,
fetchInvites,
sendMessage,
acceptInvite,
rejectInvite,
} from "./services/api";

function App() {
const [messages, setMessages] = useState([]);
const [channels, setChannels] = useState([]);
const [workspaces, setWorkspaces] = useState([]);
const [invites, setInvites] = useState([]);
const [input, setInput] = useState("");
const [showInbox, setShowInbox] = useState(false);

const [wsid, setWsid] = useState(1);
const [chid, setChid] = useState(1);

const uid = 1;

useEffect(() => {
fetchWorkspaces(uid).then(setWorkspaces);
fetchInvites(uid).then(setInvites);
}, []);

useEffect(() => {
fetchChannels(wsid).then((data) => {
setChannels(data);
if (data.length > 0) setChid(data[0].chid);
});
}, [wsid]);

useEffect(() => {
fetchMessages(chid).then(setMessages);
}, [chid]);

useEffect(() => {
const handleClick = () => setShowInbox(false);
if (showInbox) window.addEventListener("click", handleClick);
return () => window.removeEventListener("click", handleClick);
}, [showInbox]);

const handleSend = async () => {
if (!input.trim()) return;
await sendMessage(chid, uid, input);
setInput("");
fetchMessages(chid).then(setMessages);
};

const handleAccept = async (wsid) => {
await acceptInvite(wsid, uid);
fetchInvites(uid).then(setInvites);
fetchWorkspaces(uid).then(setWorkspaces);
};

const handleReject = async (wsid) => {
await rejectInvite(wsid, uid);
fetchInvites(uid).then(setInvites);
};

return (
<div style={{ padding: "20px" }}> <Inbox
     invites={invites}
     showInbox={showInbox}
     setShowInbox={setShowInbox}
     onAccept={handleAccept}
     onReject={handleReject}
   />

  <div style={{ display: "flex" }}>
    <WorkspaceList
      workspaces={workspaces}
      wsid={wsid}
      setWsid={setWsid}
    />

    <ChannelList
      channels={channels}
      chid={chid}
      setChid={setChid}
    />

    <ChatWindow
      messages={messages}
      input={input}
      setInput={setInput}
      sendMessage={handleSend}
      chid={chid}
    />
  </div>
</div>
);
}

export default App;
