#!/usr/bin/env bash
sudo tee /etc/polkit-1/rules.d/10-suspend.rules <<'POLKIT'
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.login1.suspend" ||
         action.id == "org.freedesktop.login1.suspend-multiple-sessions") &&
        subject.user == "mindset") {
        return polkit.Result.YES;
    }
});
POLKIT
sudo systemctl restart polkit
echo "Done. Tombol sleep sekarang gak bakal minta password."
