// Version 2: The agent knows the actions the Things afford, but don't know if they are available.
//            The developer has to check if they are availabe in the context of the plan.
//            If the does not check, an error will be raised.


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
        !turnOnLight("lightbulb3", "workingroom");
        !turnOnLight("lightbulb4", "workingroom");
        .


+!turnOnLight(ThingName, WorkspaceName)
    : hasAction("https://saref.etsi.org/core#TurnOn", ThingName)
    <-
        .print("Turning ", ThingName, " on using the first plan");
        joinWorkspace(WorkspaceName, WorkspaceArtId);
        invokeAction("https://saref.etsi.org/core#TurnOn", ["https://www.w3.org/2019/wot/json-schema#BooleanSchema"], [true])[artifact_name(ThingName)]
        .

+!turnOnLight(ThingName, WorkspaceName)
    : hasAction("https://saref.etsi.org/core#ToggleCommand", ThingName)
    <-
        .print("Turning ", ThingName, " on using the second plan");
        joinWorkspace(WorkspaceName, WorkspaceArtId);
        invokeAction("https://saref.etsi.org/core#ToggleCommand", ["https://www.w3.org/2019/wot/json-schema#BooleanSchema"], [true])[artifact_name(ThingName)]
        .

+!turnOnLight(ThingName, WorkspaceName)
    : true
    <- .print("No available action for ", ThingName).

{ include("inc/hypermedia.asl") }
{ include("inc/ontologies.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }