# Design-Optimization-of-Paper-Helicopter-to-Increase-Flight-Time

### <ins>Tools</ins>
R

---
### <ins>Project</ins>
Aim of the project was to improve the design of paper helicopters using experimental methods.

1. Identified Critical design factors, Using Plackett-Burma Design 36 paper helicopters (3 replications of the same design) were designed and their flight time was recorded when dropped from a height of 9 feet.
![image](https://github.com/ishankcode/Design-Optimization-of-Paper-Helicopter-to-Increase-Flight-Time/assets/66678343/aae6edbe-ed8d-4e90-a74f-a7a4cb0e1a0e)

![image](https://github.com/ishankcode/Design-Optimization-of-Paper-Helicopter-to-Increase-Flight-Time/assets/66678343/82e7419f-e86e-40df-9f87-b7fff5b6acfd)

Performing Experiment (Collecting Data)
![image](https://github.com/ishankcode/Design-Optimization-of-Paper-Helicopter-to-Increase-Flight-Time/assets/66678343/dfcda626-0bf0-438d-a13a-c6040944eef7)

2. Used Half-Normal plots and Hamada-Wu to identify the best factors along with their setting levels to maximize the goal i.e. the flight time.

    - Half normal plot analysis for Location and dispersion: <br />
      Based on this we can calculate the max flight time by determining optimum levels of parameters that minimize the variance as well.
      Final Result Max flight time  = 2.575 seconds.

      ![image](https://github.com/ishankcode/Design-Optimization-of-Paper-Helicopter-to-Increase-Flight-Time/assets/66678343/17645488-9931-4c40-9775-f59b8297c6b7)

    - Hamada-Wu Approach: <br />
    Performed stepwise regression to identify the optimum model properties.
        - Final Location Model: 𝑦=2.3258+0.2706 𝑥𝑙−0.0669 𝑥𝑤−0.0902 𝑥𝑙:𝑤+0.0917 𝑥𝑙:𝐹+0.0593 𝑥𝑤:𝑑
        - Final Dispersion Model: ln𝑠2= −2.307+0.2872 𝑥𝑑
        
     Applied 2 step procedure: minimizing variance first and then maximizing the flight time we get final result of fligh time as 2.9045 seconds.
     
 3. Validation Study: <br />
Created a paper helicopter as per the design recommendation of the final model achieved from the Hamada-Wu analysis. The result achieved of 2.954 seconds was very close to the theoretical flight time of 2.9045 seconds.
