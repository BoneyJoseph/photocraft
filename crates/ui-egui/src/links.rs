//! Project links for the PhotoCraft community build.

use serde_json::{Value, json};

use crate::PhotocraftApp;

pub const GITHUB: &str = "https://github.com/BoneyJoseph/photocraft";
pub const ISSUES: &str = "https://github.com/BoneyJoseph/photocraft/issues";

/// Help-menu links for this fork, without upstream promotion.
pub const COMMANDS: &[(&str, &str)] = &[("help.github", GITHUB), ("help.reportIssue", ISSUES)];

pub fn url_for(id: &str) -> Option<&'static str> {
    COMMANDS.iter().find(|c| c.0 == id).map(|c| c.1)
}

/// Open `url` in the system browser (a new tab on the web) and note it in the status bar. Prefers
/// the platform `open_url` service (reliable on Windows/macOS/Linux); falls back to `ctx.open_url`.
pub fn open(app: &mut PhotocraftApp, ctx: &egui::Context, url: &str) -> Value {
    let opened = app.services.open_url.as_ref().map(|f| f(url).is_ok()).unwrap_or(false);
    if !opened {
        ctx.open_url(egui::OpenUrl::new_tab(url));
    }
    let template = "Opened {url}";
    app.ui.status = crate::i18n::fmt(tl!(template), &[("url", url)]);
    json!({"url": url})
}

/// Links to source code and issue reporting for this community build.
pub fn link_row(app: &mut PhotocraftApp, ui: &mut egui::Ui) {
    let t = crate::theme::Tokens::get(ui.ctx());
    ui.horizontal_centered(|ui| {
        for (i, (label, url)) in [("Source on GitHub", GITHUB), ("Report an issue", ISSUES)].into_iter().enumerate() {
            if i > 0 {
                ui.label(egui::RichText::new("  ·  ").color(t.text_faint));
            }
            if ui.link(egui::RichText::new(label).color(t.accent)).on_hover_text(url).clicked() {
                open(app, ui.ctx(), url);
            }
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn help_links_are_owned_by_this_fork() {
        assert_eq!(url_for("help.github"), Some("https://github.com/BoneyJoseph/photocraft"));
        assert_eq!(url_for("help.reportIssue"), Some("https://github.com/BoneyJoseph/photocraft/issues"));
        assert_eq!(url_for("help.discord"), None);
        for (id, url) in COMMANDS {
            assert!(url.starts_with("https://"));
            assert!(crate::menus::is_live(id));
        }
    }
}
