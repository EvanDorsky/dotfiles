# rift local patches

`scripts/rift-build.sh` checks out the brew-installed rift tag into `~/src/rift`,
applies every `*.patch` here, builds, signs, and installs over the brew binary.
Re-run it after `brew upgrade rift` (the upgrade overwrites the patched binary).

## 0001-rehide-escaped-hidden-windows

rift hides windows on inactive workspaces by moving them off-screen, and
remembers the frame it asked for. Two things then go wrong upstream (0.5.x):

- if the app never lands *exactly* on that frame (macOS clamps windows so a
  title bar stays reachable; Spark animates in steps), the request stays
  pending forever, and every later frame change from that window is swallowed
  as "still in progress";
- every later hide request for the same frame is dropped as redundant, and a
  self-initiated move is treated as a user drag and excluded from the next
  layout pass.

Net effect: a hidden window that gets pulled back on-screen (self-raise, AppKit
re-constraining on orderFront) stays there on every workspace, forever.

The patch: an off-screen landing that isn't the exact frame counts as an
acknowledgement; a hidden window that shows up meaningfully on-screen (>64px
visible in both axes) is an escape that drops the request and triggers a
re-hide; hide requests for hidden windows are never deduplicated; and a hidden
window's self-move is never treated as a drag.

## Code signing

The binary is signed with `rift-local`, a self-signed certificate in the login
keychain (created with openssl + `security import` + `security add-trusted-cert
-p codeSign`). macOS ties the Accessibility grant to the signing identity, so a
stable certificate means rebuilds keep the permission; ad-hoc signatures change
with every build and force a re-grant. If the certificate is ever lost, recreate
it under the same name and grant Accessibility once more.
