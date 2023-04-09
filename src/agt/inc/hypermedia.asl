/*
 * Mirroring of a hypermedia environment on the local CArtAgO node
 */

+!load_environment(EnvName, EnvUrl) : true <-
  .print("[Load environment] Loading environment (entry point): ", EnvUrl);
  makeArtifact(EnvName, "ch.unisg.ics.interactions.jacamo.artifacts.yggdrasil.ContainerArtifact", [EnvUrl, "workspace"], ArtId);
  focusWhenAvailable(EnvName);
  !registerForWebSub(EnvName, ArtId).

/* Mirror hypermedia workspaces as local CArtAgO workspaces */

@l13[atomic]
+workspace(WorkspaceIRI, WorkspaceName) : true <-
  .print("[Load environment] Discovered workspace (name: ", WorkspaceName ,"): ", WorkspaceIRI);
  createWorkspace(WorkspaceName);
  joinWorkspace(WorkspaceName, WorkspaceArtId);
  // Create a hypermedia WorkspaceArtifact for this workspace.
  // Used for some operations (e.g., create artifact).
  makeArtifact(WorkspaceName, "ch.unisg.ics.interactions.jacamo.artifacts.yggdrasil.ContainerArtifact", [WorkspaceIRI, "artifact"], WkspArtId);
  focusWhenAvailable(WorkspaceName);
  !registerForWebSub(WorkspaceName, WkspArtId).

/* Mirror hypermedia artifacts in local CArtAgO workspaces */

+artifact(ArtifactIRI, ArtifactName): true <-
  .print("[Load environment] Discovered artifact (name: ", ArtifactName ,"): ", ArtifactIRI);

  makeArtifact(ArtifactName, "ch.unisg.ics.interactions.jacamo.artifacts.wot.ThingArtifact", [ArtifactIRI, false], ArtID);
  focusWhenAvailable(ArtifactName);
  !registerForWebSub(ArtifactName, ArtID).

+!registerForWebSub(ArtifactName, ArtID) : true <-
  ?websub(HubIRI, TopicIRI)[artifact_name(ArtID,_)];
  registerArtifactForNotifications(TopicIRI, ArtID, HubIRI).

-!registerForWebSub(ArtifactName, ArtID) : true <-
  .print("[Load environment] WebSub not available for artifact: ", ArtifactName).