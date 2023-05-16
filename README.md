# Personalized Artificial Pancreas System Controller For T1D Patient

This is an optimized fuzzy interference system tree controller of artificial pancreas designed for a particular patient.

### TODO

- Finish API and MATLAB connection
- Figure out how to run on MacOS
- Finish the report
- Write run instructions

### Note

quite an interesting fact is that when a high cho (897g) diet is run on a 42kg patient, the results are still pretty good, but there;s still a lot of instability.
when CCR is updated though, the system becomes more stable. E.g.:

```matlab
    % MAX INSULIN PER DAY
    MIPD = weight_ * 0.55;

    % CARBS COVERAGE RATIO
    CCR = 500 / MIPD ====> CCR = 900 / MIPD
```
