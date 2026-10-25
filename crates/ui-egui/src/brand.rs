//! Original community-build title-bar mark. The Dock icon is rendered by the macOS packaging script.

use egui::{Id, Rect, Ui};

fn rect_id() -> Id {
    Id::unique("photocraft-brand-mark-rect")
}

/// Paint a custom blue/violet photo tile in the title bar.
pub fn paint_mark(ui: &Ui, r: Rect) {
    use egui::{CornerRadius, Stroke, StrokeKind, Color32, pos2};
    let bg = Color32::from_rgb(37, 104, 225);
    ui.painter().rect(r, CornerRadius::same((r.width() * 0.22) as u8), bg, Stroke::NONE, StrokeKind::Inside);
    let inner = r.shrink(r.width() * 0.22);
    ui.painter().rect_filled(inner, CornerRadius::same((r.width() * 0.08) as u8), Color32::from_rgb(227, 242, 255));
    let base = inner.left_bottom();
    let middle = pos2(inner.center().x, inner.center().y + inner.height() * 0.12);
    let left = pos2(inner.left(), inner.bottom() - inner.height() * 0.38);
    let right = inner.right_bottom();
    ui.painter().add(egui::Shape::convex_polygon(vec![base, left, middle, right], Color32::from_rgb(67, 155, 190), Stroke::NONE));
    ui.painter().circle_filled(pos2(inner.right() - inner.width() * 0.22, inner.top() + inner.height() * 0.24), inner.width() * 0.10, Color32::from_rgb(245, 193, 107));
    ui.ctx().data_mut(|d| d.insert_temp(rect_id(), r));
}

/// The rect the mark was last painted.
#[cfg(test)]
pub fn mark_rect(ctx: &egui::Context) -> Option<Rect> {
    ctx.data(|d| d.get_temp(rect_id()))
}

#[cfg(test)]
mod tests {
    #[test]
    fn the_title_bar_paints_custom_mark() {
        let ctx = egui::Context::default();
        let mut app = crate::PhotocraftApp::new(photocraft_engine::Session::new(), crate::Services::default());
        app.custom_titlebar = true;
        let _ = ctx.run_ui(egui::RawInput::default(), |ui| crate::panels::title_bar(&mut app, ui));
        assert!(super::mark_rect(&ctx).is_some());
    }
}
