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
tipos = varfun(@class,datos,'OutputFormat','cell');

tabla_tipos = table(variables', tipos', 'VariableNames', {'NombreVariable', 'Tipo'});

for i = 1:length(variables)
    if ismember(variables{i}, {'height', 'weight', 'age', 'tea', 'coffee'})
        % Para variables continuas, muestra estadísticas descriptivas, un histograma y un diagrama de cajas y bigotes
        disp(['**Tabla de medidas de ubicación, dispersión y forma de la variable ', variables{i}, ':**'])
        disp(['Valor mínimo de ', variables{i}, ': ', num2str(min(datos.(variables{i})))]);
        disp(['Valor máximo de ', variables{i}, ': ', num2str(max(datos.(variables{i})))]);
        disp(['Media de ', variables{i}, ': ', num2str(mean(datos.(variables{i})))]);
        disp(['Mediana de ', variables{i}, ': ', num2str(median(datos.(variables{i})))]);
        disp(['Desviación estándar de ', variables{i}, ': ', num2str(std(datos.(variables{i})))]);
        disp(['Curtosis de ', variables{i}, ': ', num2str(kurtosis(datos.(variables{i})))]);
        disp(['Asimetría de ', variables{i}, ': ', num2str(skewness(datos.(variables{i})))]);
        figure; % Crea una nueva figura
        histogram(datos.(variables{i}));
        title(['Histograma de ', variables{i}]); % Agrega un título al gráfico
        xlabel(variables{i}); % Etiqueta el eje x
        ylabel('Frecuencia'); % Etiqueta el eje y
        figure; % Crea una nueva figura
        boxplot(datos.(variables{i}));
        title(['Diagrama de cajas y bigotes de ', variables{i}]); % Agrega un título al gráfico
        xlabel(variables{i}); % Etiqueta el eje x
        ylabel('Valores'); % Etiqueta el eje y
    else
        % Para variables categóricas, muestra una tabla de frecuencias y un gráfico de barras
        tab = tabulate(datos.(variables{i}));
        disp(['**Tabla de frecuencias para la variable ', variables{i}, ':**']);
        disp('Valores que toma la variable ');
        disp(tab(:,1));
        disp('Frecuencia ');
        disp(tab(:,2));
        disp('Frecuencia relativa (%) ');
        disp(tab(:,3));
        figure; % Crea una nueva figura
        bar(tab(:,2))
        title(['Gráfico de barras de ', variables{i}]); % Agrega un título al gráfico
        xlabel('Categorías'); % Etiqueta el eje x
        ylabel('Frecuencia'); % Etiqueta el eje y
        set(gca, 'XTickLabel',tab(:,1)); % Asigna las etiquetas de las categorías al eje x
    end
end

for i = 1:length(variables)
    if ismember(variables{i}, {'height', 'weight', 'age', 'tea', 'coffee'})
        % Para variables continuas, calcula los percentiles y compara con los valores mínimos y máximos
        disp(['**Análisis de percentiles para la variable ', variables{i}, ':**'])
        percentiles = prctile(datos.(variables{i}), [0 25 50 75 100]);
        disp(['Percentil 0 (mínimo) de ', variables{i}, ': ', num2str(percentiles(1))]);
        disp(['Percentil 25 de ', variables{i}, ': ', num2str(percentiles(2))]);
        disp(['Percentil 50 (mediana) de ', variables{i}, ': ', num2str(percentiles(3))]);
        disp(['Percentil 75 de ', variables{i}, ': ', num2str(percentiles(4))]);
        disp(['Percentil 100 (máximo) de ', variables{i}, ': ', num2str(percentiles(5))]);
        disp(['Diferencia entre percentil 25 y mínimo de ', variables{i}, ': ', num2str(percentiles(2)-percentiles(1))]);
        disp(['Diferencia entre percentil 75 y máximo de ', variables{i}, ': ', num2str(percentiles(5)-percentiles(4))]);
        disp('ㅤㅤㅤㅤㅤㅤ')
    end
end
