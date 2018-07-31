--This file is part of Game Master Genie.
--Copyright 2011, 2012, 2013 Chocochaos

--Game Master Genie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.
--Game Master Genie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--You should have received a copy of the GNU General Public License along with Game Master Genie. If not, see <http://www.gnu.org/licenses/>.

Xavier.Tickets = {};

-- config
Xavier.Tickets.perPage = 10;

-- vars
Xavier.Tickets.pages = 1;
Xavier.Tickets.tickets = 0;
Xavier.Tickets.onlineTickets = 0;
Xavier.Tickets.currentPage = 1;
Xavier.Tickets.currentTicket = { ["num"] = 0, ["ticketId"] = 0, ['name'] = "", ["message"] = "" };
Xavier.Tickets.order = "ticketId";
Xavier.Tickets.ascDesc = false;
Xavier.Tickets.messageOpen = false;
Xavier.Tickets.done = 0;
Xavier.Tickets.syncList = {};
Xavier.Tickets.loadingOnline = false;
--Xavier.Tickets.Colours = { ["onlineUnread"] = "ffbfbfff", ["onlineRead"] = "ffffffff", ["offlineUnread"] = "ff5f5f80", ["offlineRead"] = "ff808080" };
Xavier.Tickets.Colours = { ["current"] = "ffffffff", ["onlineUnread"] = "ffbfbfff", ["onlineRead"] = "ff5f5f7f", ["offlineUnread"] = "ffff0000", ["offlineRead"] = "ff7f0000" };

-- ticket list
Xavier.Tickets.list = {};
Xavier.Tickets.read = {};
Xavier.Tickets.idToNum = {};

function Xavier.Tickets.onLoad()
    Chronos.scheduleRepeating('ticketrefresh', 60, Xavier.Tickets.refresh);
    Xavier.Tickets.refresh();
end

-- refresh ticket list & schedule next refresh
function Xavier.Tickets.refresh()
    if not Xavier.Tickets.tempList then
        -- create empty list
        Xavier.Tickets.tempList = {};
        Xavier.Tickets.idToNum = {};
        Xavier.Tickets.tickets = 0;
		Xavier.Tickets.onlineTickets = 0;
		Xavier.Tickets.loadingOnline = false;
        -- get ticket list
		SendChatMessage(".ticket list", "GUILD");
        -- schedule next refresh
        Chronos.scheduleByName('ticketreupdate', 3, Xavier.Tickets.update);
	elseif Xavier.Tickets.loadingOnline then
		SendChatMessage(".ticket onlinelist", "GUILD");
        Chronos.scheduleByName('ticketreupdate', 3, Xavier.Tickets.update);
    end
end

-- add ticket from chat list to the addon list
function Xavier.Tickets.listTicket(ticketId, name, createStr, createStamp, lastModifiedStr, lastModifiedStamp)
    local ticketInfo = { ["ticketId"] = ticketId, ["name"] = name, ["createStr"] = createStr, ["createStamp"] = createStamp, ["lastModifiedStr"] = lastModifiedStr, ["lastModifiedStamp"] = lastModifiedStamp, ["assignedTo"] = "", ['online'] = Xavier.Tickets.loadingOnline };
    if Xavier.Tickets.tempList and not Xavier.Tickets.idToNum[ticketId] and not Xavier.Tickets.loadingOnline then
        -- add to temp list if page is being refreshed
		table.insert(Xavier.Tickets.tempList, ticketInfo);
		Xavier.Tickets.tickets = Xavier.Tickets.tickets + 1;
		Xavier.Tickets.idToNum[ticketId] = Xavier.Tickets.tickets;
	elseif Xavier.Tickets.tempList and Xavier.Tickets.loadingOnline then
		Xavier.Tickets.onlineTickets = Xavier.Tickets.onlineTickets + 1;
		if Xavier.Tickets.idToNum[ticketId] then
			Xavier.Tickets.tempList[Xavier.Tickets.idToNum[ticketId]] = ticketInfo;
		else
			table.insert(Xavier.Tickets.tempList, ticketInfo);
			Xavier.Tickets.tickets = Xavier.Tickets.tickets + 1;
			Xavier.Tickets.idToNum[ticketId] = Xavier.Tickets.tickets;
		end
    end
    -- if no new tickets come in the chat for 1 second, update the list
    Chronos.scheduleByName('ticketreupdate', 0.25, Xavier.Tickets.update);
end

-- set assignedTo for a ticket
function Xavier.Tickets.setAssigned(ticketId, assignedTo)
    -- ticket list currently being refreshed or not?
    if Xavier.Tickets.tempList and Xavier.Tickets.idToNum[ticketId] then
        Xavier.Tickets.tempList[Xavier.Tickets.idToNum[ticketId]]["assignedTo"] = assignedTo;
    elseif Xavier.Tickets.idToNum[ticketId] then
        Xavier.Tickets.list[Xavier.Tickets.idToNum[ticketId]]["assignedTo"] = assignedTo;
	else
		Chronos.schedule(0.2, Xavier.Tickets.setAssigned, ticketId, assignedTo);
    end
end

-- update ticket list
function Xavier.Tickets.update()
	-- Check onlines too?
	if not Xavier.Tickets.loadingOnline then
		Xavier.Tickets.loadingOnline = true;
		Xavier.Tickets.refresh();
	else
		Xavier.Tickets.loadingOnline = false;
		
		-- move temp list to current list and empty temp list
		if Xavier.Tickets.tempList then
			Xavier.Tickets.list = Xavier.Tickets.tempList;
			Xavier.Tickets.tempList = nil;
		end
		-- calc number of pages
		if Xavier_SavedVars.showOfflineTickets then
			Xavier.Tickets.pages = math.ceil(Xavier.Tickets.tickets/Xavier.Tickets.perPage);
		else
			Xavier.Tickets.pages = math.ceil(Xavier.Tickets.onlineTickets/Xavier.Tickets.perPage);
		end
		-- allways at least 1 page
		if Xavier.Tickets.pages < 1 then
			Xavier.Tickets.pages = 1;
		end
		-- does the page currently being viewed still exist?
		if Xavier.Tickets.currentPage > Xavier.Tickets.pages then
			Xavier.Tickets.currentPage = Xavier.Tickets.pages;
		end
		-- order ticket list
		Xavier.Tickets.sort();
	end
end

-- change ordering for ticket list
function Xavier.Tickets.changeOrder(order)
    if Xavier.Tickets.order == order then
        if Xavier.Tickets.ascDesc then
            Xavier.Tickets.ascDesc = false;
        else
            Xavier.Tickets.ascDesc = true;
        end
    else
        Xavier.Tickets.order = order;
        Xavier.Tickets.ascDesc = false;
    end
    Xavier.Tickets.currentPage = 1;
    Xavier.Tickets.sort();
end

-- order ticket list
function Xavier.Tickets.sort()
    if Xavier.Tickets.ascDesc then
        table.sort(Xavier.Tickets.list, function(a,b) return a[Xavier.Tickets.order]>b[Xavier.Tickets.order] end);
    else
        table.sort(Xavier.Tickets.list, function(a,b) return a[Xavier.Tickets.order]<b[Xavier.Tickets.order] end);
    end
    
    -- update idToNum table
    Xavier.Tickets.idToNum = {};
    for ticketNum, ticketInfo in ipairs(Xavier.Tickets.list) do
        Xavier.Tickets.idToNum[ticketInfo["ticketId"]] = ticketNum;
    end
    
    -- update the ticket window
    Xavier.Tickets.updateView();
end

-- update the ticket window
function Xavier.Tickets.updateView()
    -- Page x of y (z tickets)
    local offlineCount = Xavier.Tickets.tickets - Xavier.Tickets.onlineTickets;
    
    local plural = {["total"] = "s", ["online"] = "s", ["offline"] = "s"};
    if Xavier.Tickets.onlineTickets == 1 then
        plural["online"] = "";
    end
    if offlineCount == 1 then
        plural["offline"] = "";
    end
    if Xavier.Tickets.tickets == 1 then
        plural["total"] = "";
    end
    
    Xavier_Tickets_Main_Info_Text:SetText(Xavier.Tickets.tickets .." ticket".. plural["total"] .." (|c".. Xavier.Tickets.Colours["onlineUnread"] .. Xavier.Tickets.onlineTickets.." online,|r |c".. Xavier.Tickets.Colours["offlineUnread"] .. offlineCount.." offline|r), " ..Xavier.Tickets.done.. " done");
	Xavier_Tickets_Main_Info_Page:SetText("Page ".. Xavier.Tickets.currentPage .." of ".. Xavier.Tickets.pages);
    
    Xavier_Hud_Tickets:SetText("Tickets (|c".. Xavier.Tickets.Colours["onlineUnread"] .. Xavier.Tickets.onlineTickets .."|r / |c".. Xavier.Tickets.Colours["offlineUnread"] .. offlineCount .. "|r)");
    
    -- previous page
    if (Xavier.Tickets.currentPage == 1) then
		Xavier_Tickets_Main_Previous:Disable();
	else
		Xavier_Tickets_Main_Previous:Enable();
	end
    
    -- next page
    if (Xavier.Tickets.currentPage == Xavier.Tickets.pages) then
		Xavier_Tickets_Main_Next:Disable();
	else
		Xavier_Tickets_Main_Next:Enable();
	end
    
    -- start and end of the list on the current page
    local minTicket = 1 + ((Xavier.Tickets.currentPage - 1) * Xavier.Tickets.perPage);
	local maxTicket = Xavier.Tickets.currentPage * Xavier.Tickets.perPage;
    local num = 1;
    local i = 0;
    
    -- reset num
    Xavier.Tickets.currentTicket["num"] = 0;
    
    -- loop through tickets
    for ticketNum, ticketInfo in ipairs(Xavier.Tickets.list) do
        -- Show ticket?
        if ticketInfo["online"] or Xavier_SavedVars.showOfflineTickets then
            i = i + 1;
            if i >= minTicket and i <= maxTicket then
                -- colour in list
                local colour;
                if ticketInfo["ticketId"] == Xavier.Tickets.currentTicket["ticketId"] then
                    colour = Xavier.Tickets.Colours["current"];
                else
                    if Xavier.Tickets.read[ticketInfo["ticketId"]] then
                        if ticketInfo["online"] then
                            colour = Xavier.Tickets.Colours["onlineRead"];
                        else
                            colour = Xavier.Tickets.Colours["offlineRead"];
                        end
                    else
                        if ticketInfo["online"] then
                            colour = Xavier.Tickets.Colours["onlineUnread"];
                        else
                            colour = Xavier.Tickets.Colours["offlineUnread"];
                        end
                    end
                end
                
                -- set ticket info
                getglobal("TicketStatusButton".. num .."_ticketId"):SetText("|c".. colour .. ticketInfo["ticketId"] .."|r");
                getglobal("TicketStatusButton".. num .."_name"):SetText("|c".. colour .. ticketInfo["name"] .."|r");
                getglobal("TicketStatusButton".. num .."_createStr"):SetText("|c".. colour .. ticketInfo["createStr"] .."|r");
                getglobal("TicketStatusButton".. num .."_lastModifiedStr"):SetText("|c".. colour .. ticketInfo["lastModifiedStr"] .."|r");
                getglobal("TicketStatusButton".. num .."_assignedTo"):SetText("|c".. colour .. ticketInfo["assignedTo"] .."|r");
                getglobal("TicketStatusButton".. num):Show();
                
                getglobal("TicketStatusButton".. num).ticketId = ticketInfo["ticketId"];
                
                -- number on the ticket window
                num = num + 1;
            end
        end
    end
    if num <= Xavier.Tickets.perPage then
        for num = num, Xavier.Tickets.perPage do
            getglobal("TicketStatusButton".. num):Hide();
        end
    end
end

-- next page
function Xavier.Tickets.goToNext()
    if Xavier.Tickets.currentPage < Xavier.Tickets.pages then
        Xavier.Tickets.currentPage = Xavier.Tickets.currentPage + 1;
        Xavier.Tickets.updateView();
    end
end

-- previous page
function Xavier.Tickets.goToPrevious()
    if Xavier.Tickets.currentPage > 1 then
        Xavier.Tickets.currentPage = Xavier.Tickets.currentPage - 1;
        Xavier.Tickets.updateView();
    end
end

-- mark ticket as read
function Xavier.Tickets.markAsRead(ticketId)
	Xavier.Tickets.read[ticketId] = true;
	Xavier.Tickets.updateView();
end

-- mark ticket as unread
function Xavier.Tickets.markAsUnread(ticketId)
	Xavier.Tickets.ReadTickets[ticketId] = false;
end

function Xavier.Tickets.isOpen()
    local frame = Xavier_Tickets_Main;
	if (frame) then
        return frame:IsVisible();
    end
end

-- hide or show ticket window
function Xavier.Tickets.toggle(showOffline)
	if Xavier.Tickets.isOpen() then
        -- hide window
        Xavier_Tickets_Main:Hide();
    else
        if showOffline and not Xavier_SavedVars.showOfflineTickets then
            Xavier.Tickets.toggleOfflineTickets();
        end
        -- refresh ticket list and initiate auto-refresh
        Xavier.Tickets.onLoad();
        -- show window
        Xavier_Tickets_Main:Show();
    end
end

-- load ticket
function Xavier.Tickets.loadTicket(ticketId, num)
    if (Xavier.Tickets.currentTicket["ticketId"] and Xavier.Tickets.currentTicket["ticketId"] == ticketId) then
		Xavier.Tickets.close();
        return;
    else
        if Xavier.Tickets.idToNum[ticketId] then
            if Xavier.Tickets.list[Xavier.Tickets.idToNum[ticketId]]["name"] then
                -- update current ticket
                Xavier.Tickets.currentTicket = { ["num"] = num, ["ticketId"] = ticketId, ["name"] = Xavier.Tickets.list[Xavier.Tickets.idToNum[ticketId]]["name"], ["comment"] = "", ["message"] = "Loading..." };
                -- set title and loading text
                Xavier_Tickets_View_Title_Text:SetText(Xavier.Tickets.currentTicket["name"].."'s Ticket");
                Xavier.Tickets.showMessage();
                -- hide reading frame UNUSED ATM
                --Xavier_Tickets_View_Ticket_Reading:Hide();
                -- get ticket
                SendChatMessage(".ticket viewid ".. ticketId,"GUILD");
                -- open spy
                if Xavier_SavedVars.useSpy then
                    Xavier.Spy.spy(Xavier.Tickets.currentTicket["name"]);
                end
                -- mark as read
                Xavier.Tickets.markAsRead(ticketId);
                -- toggle frame
                Xavier_Tickets_View:Show();
                if Xavier_SavedVars.swapTicketWindows then
                    Xavier.Tickets.toggle();
                end
				-- chronos schedule and send message
				Chronos.scheduleRepeating('ticketSync', 30, Xavier.Tickets.sync);
				Xavier.Tickets.sync();
				Xavier.Tickets.displaySync()
                return;
            end
        end
	end
    Chronos.schedule(0.2, Xavier.Tickets.loadTicket, ticketId, num);
end

function Xavier.Tickets.displaySync()
	local names = {};
	local num = 0;
	for name, ticketId in pairs(Xavier.Tickets.syncList) do
		if tonumber(ticketId) == tonumber(Xavier.Tickets.currentTicket["ticketId"]) then
			table.insert(names,name);
			num = num + 1;
		end
	end
	
	if num > 0 then
		local text = "";
		for index, name in ipairs(names) do
			text = text..name;
			if index == (num-1) then
				text = text.." and ";
			elseif index < (num-1) then
				text = text..", ";
			end
		end
		Xavier_Tickets_View_Sync_Names:SetText(text);
		Xavier_Tickets_View_Ticket:SetHeight(150);
		Xavier_Tickets_View_Ticket_Frame:SetHeight(150);
        Xavier_Tickets_View_Ticket_Frame_Text:SetHeight(150);
		Xavier_Tickets_View_Sync:Show();
	else
		Xavier_Tickets_View_Ticket:SetHeight(173);
		Xavier_Tickets_View_Ticket_Frame:SetHeight(173);
        Xavier_Tickets_View_Ticket_Frame_Text:SetHeight(173);
		Xavier_Tickets_View_Sync:Hide();
	end
end

function Xavier.Tickets.sync()
	SendAddonMessage("Xavier_Sync", Xavier.Tickets.currentTicket["ticketId"], "GUILD");
end

function Xavier.Tickets.syncMessage(name, ticketId)
	if UnitName("player") ~= name then
		if not (Xavier.Tickets.syncList[name] and Xavier.Tickets.syncList[name] == ticketId) then
			Xavier.Tickets.syncList[name] = ticketId;
			if ticketId == 0 then
				Chronos.unscheduleByName('ticketSync'..name);
			else
				Chronos.scheduleByName('ticketSync'..name, 35, Xavier.Tickets.syncMessage, name, 0);
			end
			Xavier.Tickets.displaySync();
		else
			Chronos.scheduleByName('ticketSync'..name, 35, Xavier.Tickets.syncMessage, name, 0);
		end
	end
end

function Xavier.Tickets.loadComment(comment)
    Xavier.Tickets.currentTicket["comment"] = comment;
    Xavier.Tickets.showMessage();
end

function Xavier.Tickets.showMessage()
    Xavier_Tickets_View_Ticket_Frame_Text:SetText(Xavier.Tickets.currentTicket["message"]);
	Xavier_Tickets_View_Comment:SetText(Xavier.Tickets.currentTicket["comment"]);
end

function Xavier.Tickets.close()
    if Xavier.Spy.currentRequest["name"] == Xavier.Tickets.currentTicket["name"] then
        Xavier_Spy_InfoWindow:Hide();
    end
	SendAddonMessage("Xavier_Sync", "0", "GUILD");
	Chronos.unscheduleRepeating('ticketSync');
    Xavier_Tickets_View:Hide();
    Xavier.Tickets.currentTicket = { ["num"] = 0, ["ticketId"] = 0, ['name'] = "" };
    if Xavier_SavedVars.swapTicketWindows then
        Xavier.Tickets.toggle();
    end
	Xavier.Tickets.updateView();
end

-- read ticket
function Xavier.Tickets.readTicket(ticketId, message)
    if Xavier.Tickets.currentTicket["ticketId"] == ticketId then
        Xavier.Tickets.currentTicket["message"] = message;
        Xavier.Tickets.showMessage();
        return true;
    end
    return false;
end

-- set comment
function Xavier.Tickets.comment(ticketId, comment)
    if Xavier.Tickets.currentTicket["ticketId"] == ticketId then
        Xavier.Tickets.currentTicket["comment"] = comment;
        Xavier.Tickets.showMessage();
        return true;
    end
    return false;
end

--add line to ticket
function Xavier.Tickets.addLine(message)
    Xavier.Tickets.currentTicket["message"] = Xavier.Tickets.currentTicket["message"].."\n"..message;
    Xavier.Tickets.showMessage();
end

function Xavier.Tickets.delete()
    SendChatMessage(".ticket close "..Xavier.Tickets.currentTicket["ticketId"], "GUILD");
    SendChatMessage(".ticket del "..Xavier.Tickets.currentTicket["ticketId"], "GUILD");
    Xavier.Tickets.done = Xavier.Tickets.done + 1;
	local offlineCount = Xavier.Tickets.tickets - Xavier.Tickets.onlineTickets;
    Xavier.Tickets.close();
    Xavier.Tickets.refresh();
end

function Xavier.Tickets.assignToSelf()
    SendChatMessage(".ticket assign "..Xavier.Tickets.currentTicket["ticketId"].." "..UnitName("player"), "GUILD");
end

function Xavier.Tickets.assign()
    Xavier_Tickets_AssignPopup:Show();
    Xavier_Tickets_AssignPopup_GMName:SetText("");
end

function Xavier.Tickets.assignTo()
    Xavier_Tickets_AssignPopup:Hide();
    SendChatMessage(".ticket assign "..Xavier.Tickets.currentTicket["ticketId"].." "..Xavier_Tickets_AssignPopup_GMName:GetText(), "GUILD");
end

function Xavier.Tickets.unassign()
    SendChatMessage(".ticket unassign "..Xavier.Tickets.currentTicket["ticketId"], "GUILD");
end

function Xavier.Tickets.setComment()
    SendChatMessage(".ticket comment "..Xavier.Tickets.currentTicket["ticketId"].." "..Xavier_Tickets_View_Comment:GetText(), "GUILD");
end

function Xavier.Tickets.toggleSpy()
    if Xavier_Spy_InfoWindow:IsVisible() and Xavier.Tickets.currentTicket["name"] == Xavier.Spy.currentRequest["name"] then
        Xavier_Spy_InfoWindow:Hide();
    else
        Xavier.Spy.spy(Xavier.Tickets.currentTicket["name"]);
    end
end

-- add slash command to open.close ticket widnow
SLASH_TICKETS1 = "/tickets";
SlashCmdList["TICKETS"] = Xavier.Tickets.toggle;

local frame = CreateFrame("FRAME");
frame:RegisterEvent("CHAT_MSG_ADDON");

function frame:OnEvent(event, arg1)
    if event == "CHAT_MSG_ADDON" and (arg1=="Xavier_TicketSync" or arg1 =="Xavier_Sync") then
		Xavier.Tickets.syncMessage(arg4, arg2);
    end
end
frame:SetScript("OnEvent", frame.OnEvent);