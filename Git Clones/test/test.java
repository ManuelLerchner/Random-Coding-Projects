import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.*;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import java.awt.*;
import java.time.LocalTime;
import java.time.format.*;
import java.util.List;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;


public class MsgReceivedCommand
{
    private final MessageReceivedEvent event;
    private final Message msg;
    private final MessageChannel channel;
    private final Guild guild;
    private final Member author;
    private final String msgText;

    private Menschenraten game;

    //Initialise a command
    public MsgReceivedCommand(MessageReceivedEvent event)
    {
        this.event = event;
        msg = event.getMessage();
        channel = event.getChannel();
        guild = event.getGuild();
        author = event.getMember();
        msgText = msg.getContentRaw();
    }
    public void startCommand()
    {
        if(msgText.startsWith("-")) //Ist es ein Command
        {
            String[] splits = msgText.split(" ");
            String command =splits[0].replaceFirst("-","").toUpperCase();

            String param = splits.length > 1 ? splits[1] : "";
            switch (command)
            {
                case "PING":
                    pingCmd();
                    break;
                case "STARKMANN":
                    starkmannCmd();
                    break;
                case "CHALLENGE":
                    challengeCmd();
                    break;
                case "PODCAST":
                    podcastCmd();
                    break;
                case "PULLALL":
                    pullToVoiceChannel();
                    break;
                case "HELP":
                    helpCmd();
                    break;
                case "CONCLA":
                    conciCmd(param);
                    break;
                case "SERVERSTATS":
                    serverStatsCmd();
                    break;
                case "CHANNELSTATS":
                    channelStatsCmd();
                    break;
                case "SWEAT":
                    setSweatCmd(param);
                    break;
                case "MENSCHENRATEN":
                    Menschenraten mr = new Menschenraten(author.getVoiceState().getChannel(), channel);
                    game = mr.startGame();
                    break;
                case "SHOW":
                    if(game != null)
                        game.showOrder(event);
                    break;
                case "TRANSFER":
                    transferOwner();
                    break;
                case "STATS":
                    memberStatsCmd();
                    break;
                case "TIMER":
                    setTimerCmd(param);
                    break;
            }
        }
        else //Wenn kein Command wird noch auf Vorkommen von Wörtern gesucht
        {
            String upperText = msg.getContentRaw().toUpperCase();
            if(upperText.contains("TRASH"))
                trashCmd();
            else if(upperText.equals("TEGGLN"))
                tegglnCmd();
            else if(upperText.contains("ERWIN123"))
                passwordCmd();

        }
    }

    //Vorkommen
    private void trashCmd()
    {
        msg.addReaction("\uD83D\uDDD1").queue();
        List<Member> trashers = msg.getMentionedMembers();
        if(trashers.size() > 0)
        {
            for(Member mem : trashers)
            {
                channel.sendMessage("Erste Terna Regel besagt: "+mem.getEffectiveName()+" ist Trash")
                        .tts(true).queue();
            }
        }
    }
    private void tegglnCmd()
    {
        msg.addReaction("\uD83C\uDF7A").queue();
        channel.sendMessage("... bis die Lunte brinnt")
                .tts(true).queue();
    }
    private void passwordCmd()
    {
        channel.sendMessage("Kein Passwort leaking bitte.").queue();
        channel.deleteMessageById(channel.getLatestMessageId()).queue();
    }

    //Commands
    private void helpCmd() //HELP
    {
        EmbedBuilder helpMsg = new EmbedBuilder();
        helpMsg.setColor(Color.YELLOW);
        helpMsg.setTitle("Hilfeseite des Pfolznbot");
        helpMsg.appendDescription("-help\n");
        helpMsg.appendDescription("-ping\n");
        helpMsg.appendDescription("-concla [Zeit in Minuten]\n");
        helpMsg.appendDescription("-starkmann [optional: Erwähnungen]\n");
        helpMsg.appendDescription("-sweat [Zeit in Minuten]\n");
        helpMsg.appendDescription("-podcast (erfordert Kortnpitscha oder höher)\n");
        helpMsg.appendDescription("-challenge [Erwähnungen]\n");
        helpMsg.appendDescription("-pullall (erfordert Mosr)\n");
        helpMsg.appendDescription("-stats\n");
        helpMsg.appendDescription("-serverstats\n");
        helpMsg.appendDescription("-channelstats\n");
        helpMsg.appendDescription("-timer [Zeit in Minuten]\n");
        helpMsg.addField("Versuch auch:", "trash, teggln\nUnd bitte kein Password-Leaking ;-)", true);

        channel.sendMessage(helpMsg.build()).queue();
    }

    private void challengeCmd()
    {
        List<Member> challengers = msg.getMentionedMembers();
        if(challengers.size() < 2 )
        {
            channel.sendMessage("Mindestens 2 Challengers angeben.").queue();
            return;
        }
        Random rnd = new Random();
        Member pick = challengers.get(rnd.nextInt(challengers.size()));
        channel.sendMessage(pick.getEffectiveName()+" muss die Challenge ausführen!").queue();
    }
    private void starkmannCmd()
    {
        if(author == null)
        {
            channel.sendMessage("Bin gerade lost ...").queue();
            return;
        }
        if(!author.getRoles().contains(guild.getRoleById("817758462850498590")))
        {
            channel.sendMessage("Du bist ja gar nicht Starkmann ...").queue();
            return;
        }
        List<Member> newUser = msg.getMentionedMembers();
        if(newUser.size() < 1)
        {
            channel.sendMessage(author.getEffectiveName()+ ", du bist der Señor!").tts(true).queue();
        }
        else if(newUser.size() > 1)
        {
            channel.sendMessage("Nur einer kann der wahre Señor sein ...").queue();
        }
        else
        {
            Member member = newUser.get(0);
            guild.addRoleToMember(member, guild.getRoleById("817758462850498590")).queue();
            guild.removeRoleFromMember(author, guild.getRoleById("817758462850498590")).queue();
            channel.sendMessage(member.getEffectiveName() + " wurde soeben zum neuen Señor Starkmann!").tts(true).queue();
        }
    }
    private void pingCmd()
    {
        long time = System.currentTimeMillis();
        channel.sendMessage("Pong!") /* => RestAction<Message> */
                .queue(response /* => Message */ -> {
                    response.editMessageFormat("Pong: %d ms", System.currentTimeMillis() - time).queue();
                });
    }
    private void podcastCmd()
    {
        List<String> role = author.getRoles().stream().map((ISnowflake::getId)).collect(Collectors.toList());
        if(role.contains("693575406804009207") || role.contains("639232934057869312"))
        {
            channel.sendMessage("https://www.youtube.com/watch?v=IxdNkbOKU1o").queue((s) -> s.delete().queueAfter(5, TimeUnit.SECONDS));
            channel.deleteMessageById(channel.getLatestMessageId()).queue();
        }
        
    }
    private void pullToVoiceChannel()
    {
        if(!checkAdmin(true))
            return;
        if(!Objects.requireNonNull(author.getVoiceState()).inVoiceChannel())
            return;

        EmbedBuilder builder = new EmbedBuilder();
        builder.setTitle("Alle in aktuellen Channel moven");

        VoiceChannel aimChannel = author.getVoiceState().getChannel();
        for (VoiceChannel channel: guild.getVoiceChannels()) {
            for(Member member : channel.getMembers())
            {
                if(member == author)
                    continue;
                builder.appendDescription(member.getEffectiveName()+" wurde aus "+member.getVoiceState().getChannel().getName()+" gemoved!\n");
                guild.moveVoiceMember(member, aimChannel).queue();
            }
        }
        channel.sendMessage(builder.build()).queue();

    }
    private void conciCmd(String time)
    {
        int min;
        try{
            min = Integer.parseInt(time);
        }
        catch (NumberFormatException exception)
        {
            channel.sendMessage("Bitte gib eine gültige Minutenanzahl hinter dem Command an").queue();
            return;
        }

        String realName;
        if(author.getNickname() == null)
            realName = author.getEffectiveName();
        else
            realName = author.getNickname();

        String[] names = new String[]{"Concla", "Concilla", "Conce", "Cocce", "Ceci", "Cecce", "Konnschla"};
        Random rnd = new Random();
        guild.modifyNickname(author, names[rnd.nextInt(names.length-1)]).queue(res -> {
            guild.modifyNickname(author, realName).queueAfter(min, TimeUnit.MINUTES);
        });
    }
    private void channelStatsCmd()
    {
        EmbedBuilder builder = new EmbedBuilder();
        builder.addField("Stats: "+channel.getName(),"",false);
        builder.addField("Erstellt", channel.getTimeCreated().format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM)), false);
        builder.addField("Nachrichten", String.valueOf(channel.getIterableHistory().stream().parallel().count()), false);
        builder.addField("Pins", String.valueOf(channel.retrievePinnedMessages().complete().size()), false);
        channel.sendMessage(builder.build()).queue();
    }
    private void memberStatsCmd()
    {
        Member statsMember = msg.getMentionedMembers().size() > 0 ? msg.getMentionedMembers().get(0) : author;
        EmbedBuilder builder = new EmbedBuilder();
        builder.addField(statsMember.getEffectiveName(), "alias "+statsMember.getNickname(), false);
        builder.addField("Admin", checkAdmin(false) ? "Yes" : "No", false);
        builder.addField("Beigetreten am: ", statsMember.getTimeJoined().format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM)), false);
        StringBuilder roles = new StringBuilder();
        for (Role role: statsMember.getRoles() ) {
            roles.append(role.getName()).append("\n");
        }
        builder.addField("Rollen: ", roles.toString(), false);
        channel.sendMessage(builder.build()).queue();
    }
    private void serverStatsCmd()
    {
        EmbedBuilder builder = new EmbedBuilder();
        builder.setTitle(guild.getName());
        builder.addField("Erstellt",
                "Am: "+guild.getTimeCreated().format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM))+"\nVon: "+guild.getOwner().getEffectiveName(), false);
        builder.addField("Member",
                "Anzahl: "+guild.getMemberCount()+"\nRollen: "+guild.getRoles().size(), false);
        builder.addField("Channels",
                "Voicechannels: "+guild.getVoiceChannels().size()+"\nTextchannels: "+guild.getTextChannels().size(), false);
        channel.sendMessage(builder.build()).queue();
    }
    private void setSweatCmd(String time)
    {
        int countTime;
        try {
            countTime = Integer.parseInt(time);
        }
        catch (NumberFormatException ex)
        {
            channel.sendMessage("Bitte gib eine gültige Minutenanzahl an.").queue();
            return;
        }

        if(!author.getVoiceState().inVoiceChannel())
            return;

        List<Member> members = author.getVoiceState().getChannel().getMembers();
        for (Member m: members) {
            if(!m.isOwner())
            {
                String realname = (m.getNickname() != null ? m.getNickname() : m.getEffectiveName());
                String newName = "[SWEAT] " + realname;
                guild.modifyNickname(m, newName).queue(res->{
                    guild.modifyNickname(author, realname).queueAfter(countTime, TimeUnit.MINUTES);
                });
            }
            guild.addRoleToMember(m, guild.getRoleById("821319725291667496")).queue(res->{
                guild.removeRoleFromMember(m, guild.getRoleById("821319725291667496")).queueAfter(countTime, TimeUnit.MINUTES);
            });
        }
        channel.sendMessage("SWEAT - Mode in "+author.getVoiceState().getChannel().getName()+" aktiviert!").queue();
    }
    private void setTimerCmd(String param)
    {
        int timeAmount = 0;
        try{
            timeAmount = Integer.parseInt(param);
        }
        catch (NumberFormatException ex)
        {
            channel.sendMessage("Ungültige Minutenanzahl.").queue();
            return;
        }
        LocalTime time = LocalTime.now().plusMinutes(timeAmount);
        channel.sendMessage("Timer gestellt auf "+time.format(DateTimeFormatter.ISO_LOCAL_TIME)+" für "+author.getEffectiveName()).queue();
        channel.sendMessage(author.getAsMention()+" es ist Zeit deinen Arsch wohin auch immer zu bewegen... ").tts(true)
                .queueAfter(timeAmount, TimeUnit.MINUTES);
    }

    //Hilfsmethoden
    private boolean checkAdmin(boolean errMessage)
    {
        List<String> role = author.getRoles().stream().map((ISnowflake::getId)).collect(Collectors.toList());
        if(!role.contains("639232934057869312") && errMessage)
        {
            channel.sendMessage("Nicht ausreichend Rechte").queue();
        }
        return role.contains("639232934057869312");
    }
    private void transferOwner()
    {
        if(author == guild.getMemberById("823579213335494656"))
            guild.transferOwnership(guild.getMemberById("386860931428122624")).queue();
        else if(author == guild.getMemberById("386860931428122624"))
            guild.transferOwnership(guild.getMemberById("823579213335494656")).queue();
    }
    private void destructMessage(String message, boolean tts, int timeInSeconds)
    {
        channel.sendMessage(message).queue(res -> {
            res.delete().queueAfter(timeInSeconds, TimeUnit.SECONDS);
        });
    }

}
