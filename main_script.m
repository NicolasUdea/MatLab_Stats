datos = readtable("nutrition_elderly.csv");
generos = datos.gender == 1; % Esto da como resultado un logical array

hombres = 0;
mujeres = 0;

for i = 1:length(generos)
    if generos(i) == 1
        hombres = hombres + 1;
    else
        mujeres = mujeres + 1;
    end
end

hombres; % Total de hombres
mujeres; % Total de mujeres
total_muestra = hombres + mujeres

edades = datos.age; % Esto da como resultado un array con las edades
min_edad = min(edades);
max_edad = max(edades);

variables_cantidad = length(datos.Properties.VariableNames);

variables = datos.Properties.VariableNames;
tipos = varfun(@class, datos, 'OutputFormat', 'cell');

tabla_tipos = table(variables', tipos', ...
                    'VariableNames', {'NombreVariable', 'Tipo'});

for i = 1:length(variables)
    if ismember(variables{i}, {'height', 'weight', 'age', 'tea', 'coffee'})
        % Para variables continuas, muestra estadísticas descriptivas, 
        % un histograma y un diagrama de cajas y bigotes
        disp(['**Tabla de medidas de la variable ', ...
              variables{i}, ':**'])
        disp(['Valor mínimo de ', variables{i}, ': ', ...
              num2str(min(datos.(variables{i})))]);
        disp(['Valor máximo de ', variables{i}, ': ', ...
              num2str(max(datos.(variables{i})))]);
        disp(['Media de ', variables{i}, ': ', ...
              num2str(mean(datos.(variables{i})))]);
        disp(['Mediana de ', variables{i}, ': ', ...
              num2str(median(datos.(variables{i})))]);
        disp(['Desviación estándar de ', variables{i}, ': ', ...
              num2str(std(datos.(variables{i})))]);
        disp(['Curtosis de ', variables{i}, ': ', ...
              num2str(kurtosis(datos.(variables{i})))]);
        disp(['Asimetría de ', variables{i}, ': ', ...
              num2str(skewness(datos.(variables{i})))]);
        figure; % Crea una nueva figura
        histogram(datos.(variables{i}));
        title(['Histograma de ', variables{i}]);
        xlabel(variables{i}); % Etiqueta el eje x
        ylabel('Frecuencia'); % Etiqueta el eje y
        figure; % Crea una nueva figura
        boxplot(datos.(variables{i}));
        title(['Diagrama de cajas y bigotes de ', variables{i}]);
        xlabel(variables{i}); % Etiqueta el eje x
        ylabel('Valores'); % Etiqueta el eje y
    else
        % Para variables categóricas, muestra una tabla de frecuencias 
        % y un gráfico de barras
        tab = tabulate(datos.(variables{i}));
        disp(['**Tabla de frecuencias para la variable ', ...
            variables{i}, ':**']);
        disp('Valores que toma la variable ');
        disp(tab(:,1));
        disp('Frecuencia ');
        disp(tab(:,2));
        disp('Frecuencia relativa (%) ');
        disp(tab(:,3));
        figure; % Crea una nueva figura
        bar(tab(:,2))
        title(['Gráfico de barras de ', variables{i}]);
        xlabel('Categorías');
        ylabel('Frecuencia');
        set(gca, 'XTickLabel',tab(:,1));
    end
end

for i = 1:length(variables)
    if ismember(variables{i}, {'height', 'weight', 'age', 'tea', 'coffee'})
        % Para variables continuas, calcula los percentiles 
        % y compara con los valores mínimos y máximos
        disp(['**Análisis de percentiles para la variable ', ...
              variables{i}, '**'])
        percentiles = prctile(datos.(variables{i}), [0 25 50 75 100]);
        disp(['Percentil 0 (mínimo) de ', variables{i}, ': ', ...
              num2str(percentiles(1))]);
        disp(['Percentil 25 de ', variables{i}, ': ', ...
              num2str(percentiles(2))]);
        disp(['Percentil 50 (mediana) de ', variables{i}, ': ', ...
              num2str(percentiles(3))]);
        disp(['Percentil 75 de ', variables{i}, ': ', ...
              num2str(percentiles(4))]);
        disp(['Percentil 100 (máximo) de ', variables{i}, ': ', ...
              num2str(percentiles(5))]);
        disp(['Diferencia entre percentil 25 y mínimo de ', ...
              variables{i}, ': ', num2str(percentiles(2)-percentiles(1))]);
        disp(['Diferencia entre percentil 75 y máximo de ', ...
              variables{i}, ': ', num2str(percentiles(5)-percentiles(4))]);
        disp('ㅤㅤㅤㅤㅤㅤ')
    end
end

for i = 1:length(variables)
    if ismember(variables{i}, {'height', 'weight', 'age', 'tea', 'coffee'})
        % Para variables continuas, calcula los percentiles 
        % e identifica los valores atípicos
        disp(' ');
        disp('=====================================');
        disp(' ');
        disp(['**Análisis de valores atípicos para la variable ', ...
              variables{i}, '**'])
        Q1 = prctile(datos.(variables{i}), 25);
        Q3 = prctile(datos.(variables{i}), 75);
        IQR = Q3 - Q1;
        lower_bound = Q1 - 1.5 * IQR;
        upper_bound = Q3 + 1.5 * IQR;
        outliers = datos.(variables{i}) < lower_bound | ...
                    datos.(variables{i}) > upper_bound;
        disp(['Número de valores atípicos en ', variables{i}, ...
              ': ', num2str(sum(outliers))]);
    end
end

grupo_hombres = datos(datos.gender == 1, :);
grupo_mujeres = datos(datos.gender == 2, :);
edad_hombres = grupo_hombres.age;
edad_mujeres = grupo_mujeres.age;

% Crear histogramas para la variable 'age' en cada grupo
figure;
subplot(2,1,1);
histogram(edad_hombres);
title('Distribución de edades para hombres');
xlabel('Edad');
ylabel('Frecuencia');

subplot(2,1,2);
histogram(edad_mujeres, 'FaceColor', 'm');
title('Distribución de edades para mujeres');
xlabel('Edad');
ylabel('Frecuencia');

% Extraer las variables de interés
altura = datos.height;
peso = datos.weight;

% Crear un gráfico de dispersión
figure;
scatter(altura, peso, 15, peso, 'filled');
colormap(jet); % Crea un degradado de colores tipo arcoiris (estético)
title('Relación entre altura y peso');
xlabel('Altura (cm)');
ylabel('Peso (kg)');

matriz_correlacion = corrcoef(table2array(datos));

% Visualizar la matriz de correlación
figure;
imagesc(matriz_correlacion);
colorbar; % Agrega una barra de colores
title('Matriz de correlación');
xlabel('Variables');
ylabel('Variables');

% Etiquetas de los ejes x e y
xticks(1:length(datos.Properties.VariableNames));
xticklabels(datos.Properties.VariableNames);
xtickangle(90); % Rotar las etiquetas 90 grados
yticks(1:length(datos.Properties.VariableNames));
yticklabels(datos.Properties.VariableNames);

% Realizar el análisis de varianza (ANOVA) para cada variable
for i = 1:width(datos)
    disp('=====================================');
    disp(['Análisis de varianza ANOVA para ', ...
        datos.Properties.VariableNames{i}, ':']);
    [p, tbl, stats] = anova1(table2array(datos(:,i)));
    disp(tbl);
    disp('=====================================');
end
