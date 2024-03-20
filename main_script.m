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
    disp(['Tabla de frecuencias para ', variables{i}])
    disp(tabulate(datos.(variables{i})))
end
