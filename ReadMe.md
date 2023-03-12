# Swarm-Simulation-Identification
## Introduction
This repo contains a swarm simulation Model created by Simulink and an identification programme writen by Matlab with sweepsine velocity command.


## Requirements
1. Matlab (2022b)
2. Simulink (2022b)
3. System Identification Toolbox


## Usage
### 1. Parameter Setting: 
- In `main.m`, you can adjust settings about sweepsine.
- In `initial_conditions_and_parameters.m`, you can adjust settings about noise, delay etc. and tune controller parameters.

### 2. Run Simlation  
Run `main.m`, then two figures will be generated:
- Origin Simulation Data
- Identification Result Data

### 3. Check Identification Result
All data will be saved to `./identify/{amplitude}-{f0}-{f1}-{time}-{height}`. Identification result is saved as `identify_result.mat` with three cases:

```matlab
ex: origin data
	ex.t 		% time array
	ex.in		% velocity cmd data
	ex.in_v_int	% position cmd data
	ex.out_p	% position data
	ex.out_v	% velocity data
vv: vel_cmd -> v
vp: vel_cmd -> p
vpv: vel_cmd -> p -> v
```

They have the same structure to store results:

```matlab
vv.tf	% tranfer function
vv.fit	% fit percentage
vv.res	% tranfer function model response data
```

