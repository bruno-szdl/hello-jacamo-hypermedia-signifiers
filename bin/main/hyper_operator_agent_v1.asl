// Version 1: The agent does not know the actions afforded by the Things.
//            The developer has to know exactly which are the afforded actions to build the agent.

/* Initial beliefs and rules */

// URL of the smartbuilding
env_url("http://192.168.15.8:8080/environments/smartbuilding/").

!start.

/* Plans */

+!start
    :
        env_url(Url)
    <-
        makeArtifact("notification-server", "ch.unisg.ics.interactions.jacamo.artifacts.yggdrasil.NotificationServerArtifact", ["localhost", 8081], _);

        // Loading environment
        print("############# Loading environment #############\n");
        !load_environment("smartbuilding", Url);
        .wait(1000);
        .print("[Load environment] Finished loading the environment \n\n");

        print("############# Trying to Switch on lights #############\n");
        !turnOnLight("lightbulb1", "meetingroom");
        !turnOnLight("lightbulb2", "meetingroom");
        .

+!turnOnLight(ThingName, WorkspaceName)
    : true
    <-
        .print("Turning ", ThingName, " on");
        joinWorkspace(WorkspaceName, WorkspaceArtId);
        invokeAction("https://saref.etsi.org/core#ToggleCommand", ["https://www.w3.org/2019/wot/json-schema#BooleanSchema"], [true])[artifact_name(ThingName)]
        .

{ include("inc/hypermedia.asl") }
{ include("inc/ontologies.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }