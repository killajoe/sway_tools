# workspace_layout
Example to create a workspace with a fixed layout on sway startup

this example needs telegram to be set to bind to the workspace in addition: 

`assign [app_id="org.telegram.desktop"] $ws2`  in sway config (or dropin)


Layout:

┌──────────────────────────┐┌───────────────────┐

│ glances                  ││ telegram          │

│                          ││                   │

│                          ││                   │

│                          ││                   │

│                          ││                   │

│                          ││                   │

│                          ││                   │

│                          ││                   │

│                          ││                   │

└──────────────────────────┘│                   │

┌──────────────────────────┐│                   │

│ journal                  ││                   │

│                          ││                   │

│                          ││                   │

└──────────────────────────┘└───────────────────┘
