import { useEffect, useState } from "react";
import Inbox from "../components/Inbox";
import WorkspaceList from "../components/WorkspaceList";
import ChannelList from "../components/ChannelList";
import ChatWindow from "../components/ChatWindow";

import {
  fetchWorkspaces,
  fetchChannels,
  fetchMessages,
  fetchInvites,
  sendMessage,
  acceptInvite,
  rejectInvite,
} from "../services/api";

function ChatPage({ user, setUser }) {
  const [messages, setMessages] = useState([]);
  const [channels, setChannels] = useState([]);
  const [workspaces, setWorkspaces] = useState([]);
  const [invites, setInvites] = useState([]);
  const [input, setInput] = useState("");
  const [showInbox, setShowInbox] = useState(false);

  const [wsid, setWsid] = useState(null);
  const [chid, setChid] = useState(null);

  // Load initial data
  useEffect(() => {
    fetchWorkspaces().then(setWorkspaces);
    fetchInvites().then(setInvites);
  }, []);

  // When workspace changes → load channels
  useEffect(() => {
    if (!wsid) return;

    fetchChannels(wsid).then((data) => {
      setChannels(data);
      if (data.length > 0) setChid(data[0].chid);
    });
  }, [wsid]);

  // When channel changes → load messages
  useEffect(() => {
    if (!chid) return;

    fetchMessages(chid).then(setMessages);
  }, [chid]);

  // Close inbox on outside click
  useEffect(() => {
    const handleClick = () => setShowInbox(false);
    if (showInbox) window.addEventListener("click", handleClick);
    return () => window.removeEventListener("click", handleClick);
  }, [showInbox]);

  // Send message 
  const handleSend = async () => {
    if (!input.trim()) return;

    await sendMessage(chid, input);
    setInput("");

    fetchMessages(chid).then(setMessages);
  };

  // Accept invite 
  const handleAccept = async (id, type) => {
    await acceptInvite(id, type);

    fetchInvites().then(setInvites);
    fetchWorkspaces().then(setWorkspaces);
  };

  // Reject invite
  const handleReject = async (id, type) => {
    await rejectInvite(id, type);

    fetchInvites().then(setInvites);
  };

  return (
    <div style={{ padding: "20px" }}>
      <Inbox
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

export default ChatPage;
