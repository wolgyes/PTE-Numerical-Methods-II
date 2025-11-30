function interactive_transform()
% INTERACTIVE_TRANSFORM - Interaktiv affin transzformacio demo
%
% Hasznalat:
%   1. Kattints a "Haromszog letrehozasa" gombra
%   2. Kattints 3 pontot a grafikonra
%   3. Hasznald a csuszkakat a transzformacio valtoztatasahoz
%   A forgatas a sulypont korul tortenik!

    % Valtozok a GUI allapothoz (nested fuggvenyek osztoznak rajtuk)
    original_points = [];
    centroid = [0; 0];

    % Letrehozzuk az ablakot
    fig = figure('Name', 'Interaktiv Affin Transzformacio', ...
                 'NumberTitle', 'off', ...
                 'Position', [100 100 900 650]);

    % Grafikon terulet
    ax_main = axes('Parent', fig, ...
                   'Position', [0.05 0.15 0.55 0.8]);
    axis(ax_main, 'equal');
    grid(ax_main, 'on');
    hold(ax_main, 'on');
    xlim(ax_main, [-10 10]);
    ylim(ax_main, [-10 10]);
    plot(ax_main, [-10 10], [0 0], 'k-', 'LineWidth', 0.5);
    plot(ax_main, [0 0], [-10 10], 'k-', 'LineWidth', 0.5);
    title(ax_main, 'Kattints a "Haromszog letrehozasa" gombra');
    xlabel(ax_main, 'X');
    ylabel(ax_main, 'Y');

    % Plot handlerek
    h_original = plot(ax_main, NaN, NaN, 'bo-', 'MarkerSize', 10, ...
                      'MarkerFaceColor', 'b', 'LineWidth', 2, ...
                      'DisplayName', 'Eredeti');
    h_transformed = plot(ax_main, NaN, NaN, 'rs-', 'MarkerSize', 10, ...
                         'MarkerFaceColor', 'r', 'LineWidth', 2, ...
                         'DisplayName', 'Transzformalt');
    h_centroid = plot(ax_main, NaN, NaN, 'g+', 'MarkerSize', 15, ...
                      'LineWidth', 3, 'DisplayName', 'Sulypont');

    % Transzformacios nyilak (quiver) - 3 darab a 3 csucshoz
    h_arrows = gobjects(3, 1);
    for i = 1:3
        h_arrows(i) = quiver(ax_main, NaN, NaN, NaN, NaN, 0, ...
                             'Color', [0 0.7 0], 'LineWidth', 1.5, ...
                             'MaxHeadSize', 0.5, 'HandleVisibility', 'off');
    end

    legend(ax_main, 'Location', 'northeast');

    % --- GOMBOK ---
    uicontrol('Style', 'pushbutton', 'String', 'Haromszog letrehozasa', ...
              'Position', [620 580 150 30], ...
              'Callback', @addTriangleCallback, ...
              'FontSize', 10);

    uicontrol('Style', 'pushbutton', 'String', 'Reset forgatas', ...
              'Position', [780 580 100 30], ...
              'Callback', @resetCallback, ...
              'FontSize', 10);

    uicontrol('Style', 'pushbutton', 'String', 'Pelda haromszog', ...
              'Position', [620 540 150 30], ...
              'Callback', @exampleCallback, ...
              'FontSize', 10);

    % --- CSUSZKAK ---
    slider_y = 480;
    slider_gap = 45;

    % Forgatas
    uicontrol('Style', 'text', 'String', 'Forgatas (fok):', ...
              'Position', [620 slider_y 100 20], 'FontSize', 10, ...
              'HorizontalAlignment', 'left');
    sl_rotation = uicontrol('Style', 'slider', ...
              'Min', -180, 'Max', 180, 'Value', 0, ...
              'Position', [720 slider_y 130 20], ...
              'Callback', @sliderCallback);
    txt_rotation = uicontrol('Style', 'text', 'String', '0', ...
              'Position', [855 slider_y 40 20], 'FontSize', 10);

    slider_y = slider_y - slider_gap;

    % Eltolas X
    uicontrol('Style', 'text', 'String', 'Eltolas X:', ...
              'Position', [620 slider_y 100 20], 'FontSize', 10, ...
              'HorizontalAlignment', 'left');
    sl_trans_x = uicontrol('Style', 'slider', ...
              'Min', -10, 'Max', 10, 'Value', 0, ...
              'Position', [720 slider_y 130 20], ...
              'Callback', @sliderCallback);
    txt_trans_x = uicontrol('Style', 'text', 'String', '0.00', ...
              'Position', [855 slider_y 40 20], 'FontSize', 10);

    slider_y = slider_y - slider_gap;

    % Eltolas Y
    uicontrol('Style', 'text', 'String', 'Eltolas Y:', ...
              'Position', [620 slider_y 100 20], 'FontSize', 10, ...
              'HorizontalAlignment', 'left');
    sl_trans_y = uicontrol('Style', 'slider', ...
              'Min', -10, 'Max', 10, 'Value', 0, ...
              'Position', [720 slider_y 130 20], ...
              'Callback', @sliderCallback);
    txt_trans_y = uicontrol('Style', 'text', 'String', '0.00', ...
              'Position', [855 slider_y 40 20], 'FontSize', 10);

    % --- 3x3 MATRIX KIJELZO ---
    slider_y = slider_y - slider_gap - 20;
    uicontrol('Style', 'text', 'String', '3x3 Transzformacios matrix:', ...
              'Position', [620 slider_y 200 20], 'FontSize', 11, ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold');

    slider_y = slider_y - 70;
    txt_matrix = uicontrol('Style', 'text', ...
              'String', sprintf('[  1.00   0.00   0.00 ]\n[  0.00   1.00   0.00 ]\n[  0.00   0.00   1.00 ]'), ...
              'Position', [620 slider_y 270 65], 'FontSize', 11, ...
              'HorizontalAlignment', 'left', 'FontName', 'FixedWidth');

    % Sulypont kijelzo
    slider_y = slider_y - 35;
    uicontrol('Style', 'text', 'String', 'Sulypont (forgasi kozeppont):', ...
              'Position', [620 slider_y 200 20], 'FontSize', 10, ...
              'HorizontalAlignment', 'left', 'FontWeight', 'bold');

    slider_y = slider_y - 20;
    txt_centroid = uicontrol('Style', 'text', ...
              'String', '( -.-- , -.-- )', ...
              'Position', [620 slider_y 150 20], 'FontSize', 10, ...
              'HorizontalAlignment', 'left', 'FontName', 'FixedWidth');

    % Info szoveg alul
    uicontrol('Style', 'text', ...
              'String', 'Kek = eredeti, Piros = transzformalt, Zold + = sulypont. Forgatas a sulypont korul!', ...
              'Position', [50 10 550 25], 'FontSize', 9, ...
              'HorizontalAlignment', 'left');

    % --- CALLBACK FUGGVENYEK ---

    function addTriangleCallback(~, ~)
        title(ax_main, 'Kattints 3 pontot! (ESC = megse)');
        disp('Kattints 3 pontot a haromszoghoz...');

        pts = [];
        temp_plot = plot(ax_main, NaN, NaN, 'co', 'MarkerSize', 12, 'MarkerFaceColor', 'cyan');

        for k = 1:3
            try
                [x, y, button] = ginput(1);

                if isempty(button) || button == 27
                    delete(temp_plot);
                    title(ax_main, 'Megszakitva');
                    return;
                end

                pts = [pts; x, y];
                set(temp_plot, 'XData', pts(:,1), 'YData', pts(:,2));
                drawnow;
                fprintf('  Pont %d: (%.2f, %.2f)\n', k, x, y);
            catch
                delete(temp_plot);
                return;
            end
        end

        delete(temp_plot);

        % Haromszog bezarasa es sulypont szamitas
        original_points = [pts; pts(1,:)];  % Bezart haromszog
        centroid = [mean(pts(:,1)); mean(pts(:,2))];

        set(h_original, 'XData', original_points(:,1), 'YData', original_points(:,2));
        set(h_centroid, 'XData', centroid(1), 'YData', centroid(2));
        set(txt_centroid, 'String', sprintf('( %.2f , %.2f )', centroid(1), centroid(2)));

        title(ax_main, 'Kesz! Hasznald a csuszkakat.');
        disp('Haromszog rogzitve. Mozgasd a csuszkakat!');
        sliderCallback([], []);
    end

    function resetCallback(~, ~)
        set(sl_rotation, 'Value', 0);
        set(sl_trans_x, 'Value', 0);
        set(sl_trans_y, 'Value', 0);

        set(txt_rotation, 'String', '0');
        set(txt_trans_x, 'String', '0.00');
        set(txt_trans_y, 'String', '0.00');

        sliderCallback([], []);
    end

    function exampleCallback(~, ~)
        % Pelda haromszog
        pts = [0 0; 4 0; 2 3];
        original_points = [pts; pts(1,:)];
        centroid = [mean(pts(:,1)); mean(pts(:,2))];

        set(h_original, 'XData', original_points(:,1), 'YData', original_points(:,2));
        set(h_centroid, 'XData', centroid(1), 'YData', centroid(2));
        set(txt_centroid, 'String', sprintf('( %.2f , %.2f )', centroid(1), centroid(2)));

        title(ax_main, 'Pelda haromszog betoltve. Mozgasd a csuszkakat!');
        disp('Pelda haromszog betoltve.');

        resetCallback([], []);
    end

    function sliderCallback(~, ~)
        if isempty(original_points)
            return;
        end

        % Csuszka ertekek
        rotation = get(sl_rotation, 'Value');
        trans_x = get(sl_trans_x, 'Value');
        trans_y = get(sl_trans_y, 'Value');

        % Szovegek frissitese
        set(txt_rotation, 'String', sprintf('%.0f', rotation));
        set(txt_trans_x, 'String', sprintf('%.2f', trans_x));
        set(txt_trans_y, 'String', sprintf('%.2f', trans_y));

        % Forgatas szoge radianban
        theta = rotation * pi / 180;
        c = cos(theta);
        s = sin(theta);

        % Sulypont koordinatak
        cx = centroid(1);
        cy = centroid(2);

        % Pontok transzformalasa (sulypont koruli forgatas + eltolas)
        n = size(original_points, 1);
        transformed = zeros(n, 2);
        for i = 1:n
            % Sulypont koruli forgatas
            px = original_points(i, 1) - cx;
            py = original_points(i, 2) - cy;

            rx = c * px - s * py;
            ry = s * px + c * py;

            % Visszatolás + eltolas
            transformed(i, 1) = rx + cx + trans_x;
            transformed(i, 2) = ry + cy + trans_y;
        end

        % Plot frissites
        set(h_transformed, 'XData', transformed(:,1), 'YData', transformed(:,2));

        % Transzformacios nyilak frissitese (eredeti -> transzformalt)
        for i = 1:3
            ox = original_points(i, 1);
            oy = original_points(i, 2);
            dx = transformed(i, 1) - ox;
            dy = transformed(i, 2) - oy;
            set(h_arrows(i), 'XData', ox, 'YData', oy, 'UData', dx, 'VData', dy);
        end

        % AFFIN2 hasznalata a 3x3 matrix kiszamitasahoz
        % Eredeti haromszog (3 pont, 2x3 matrix)
        triangle1 = original_points(1:3, :)';  % 2x3

        % Transzformalt haromszog (3 pont, 2x3 matrix)
        triangle2 = transformed(1:3, :)';  % 2x3

        % Affin2 meghivasa - visszaadja a 3x3 homogen matrixot
        M = affin2(triangle1, triangle2);

        % Matrix kijelzes
        set(txt_matrix, 'String', sprintf('[%7.3f %7.3f %7.3f ]\n[%7.3f %7.3f %7.3f ]\n[%7.3f %7.3f %7.3f ]', ...
            M(1,1), M(1,2), M(1,3), M(2,1), M(2,2), M(2,3), M(3,1), M(3,2), M(3,3)));

        drawnow;
    end

end
