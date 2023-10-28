---
marp: true
title: Assessing model accuracy
author: David Orme
theme: gaia
style: |
  .columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
  .columns3 {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 1rem;
  }
  .columns12 {
    display: grid;
    grid-template-columns:  1fr 2fr;
    gap: 1rem;
  }
  .columns21 {
    display: grid;
    grid-template-columns:  2fr 1fr;
    gap: 1rem;
  }
---

<!-- markdownlint-disable MD024 MD025 MD033 MD035 MD036-->

# Assessing Model Accuracy

## David Orme

![bg width:400px](../shared_images/World3D_600.png)



---

# Overview

- The confusion matrix
- Measures of model accuracy
- Thresholds for continuous predictions
- Application to Species Distribution Models

---

# MODIS land cover classification

![MODIS Confusion Matrix w:850](images/MODIS_confusion_matrix.png)

Accuracy = 21906 / 29877 = 73.3%

----

# A simpler confusion matrix

Zoom in on just two of those categories:

![w:800](images/MODIS_confusion_matrix_zoom.png)

Model predicts: Is this evergreen forest needleleaf or broadleaf



----

# Accuracy

<div class="leftpad">

Easy to calculate **accuracy**:

</div>

<div class="vs"></div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Needle </th>
   <th style="text-align:right;"> Pred. Broad </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Needle </td>
   <td style="text-align:right;"> 1460 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Broad </td>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:right;"> 4889 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 1491 </td>
   <td style="text-align:right;"> 4931 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>

$$A = \frac{1460 + 4889}{1460 + 4889 + 42 +31} = 98.9\%$$

----

# Accuracy

<div class="leftpad">

But **random** models have ~50% accuracy!

</div>

<div class="vs"></div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Needle </th>
   <th style="text-align:right;"> Pred. Broad </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Needle </td>
   <td style="text-align:right;"> 752 </td>
   <td style="text-align:right;"> 750 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Broad </td>
   <td style="text-align:right;"> 2479 </td>
   <td style="text-align:right;"> 2441 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 3231 </td>
   <td style="text-align:right;"> 3191 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>

$$A = \frac{752 + 2441}{6422} = 49.7\%$$

----

# Accuracy

<div class="leftpad">

Bad models: **everything is a broadleaf**

</div>

<div class="vs"></div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Needle </th>
   <th style="text-align:right;"> Pred. Broad </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Needle </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1502 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Broad </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4920 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6422 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>

$$A = \frac{0 + 4920}{6422} = 76.6\%$$

----

# Prevalence

Proportion of the observed positive outcomes


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Pos </th>
   <th style="text-align:right;"> Pred. Neg </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:right;"> 1460 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:right;"> 4889 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 1491 </td>
   <td style="text-align:right;"> 4931 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>

$$\mbox{Prevalence} = \frac{1502 }{6422} = 0.234$$

<!--
Switching to POS NEG
-->

----

# Accuracy

And **accuracy is affected by prevalence**


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Pos </th>
   <th style="text-align:right;"> Pred. Neg </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6407 </td>
   <td style="text-align:right;"> 6407 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 6442 </td>
   <td style="text-align:right;"> 6442 </td>
  </tr>
</tbody>
</table>

$$A = \frac{0 + 6407}{6422} = 99.5\%$$

----

# Prediction outcomes

Giving some simple names to the four outcomes:

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Pred. Pos </th>
   <th style="text-align:center;"> Pred. Neg </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:center;"> True</br>Positive </td>
   <td style="text-align:center;"> False</br>Negative </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:center;"> False</br>Positive </td>
   <td style="text-align:center;"> True</br>Negative </td>
  </tr>
</tbody>
</table>

----

# Prediction outcomes

Other less obvious names do get used:

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Pred. Pos </th>
   <th style="text-align:center;"> Pred. Neg </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:center;"> True</br>Positive </td>
   <td style="text-align:center;"> Type II</br>Error </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:center;"> Type I</br>Error </td>
   <td style="text-align:center;"> True</br>Negative </td>
  </tr>
</tbody>
</table>

----

# Rates of outcomes

Divide the four outcomes by the **observed** positive and negative counts to give **rates**:

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Pred. Pos </th>
   <th style="text-align:center;"> Pred. Neg </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:center;"> True</br>Positive</br>Rate </td>
   <td style="text-align:center;"> False</br>Negative</br>Rate </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:center;"> False</br>Positive</br>Rate </td>
   <td style="text-align:center;"> True</br>Negative</br>Rate </td>
  </tr>
</tbody>
</table>

----

# Rates of outcomes

Calculate those values:

| | Pred. Pos | Pred. Neg |  Sum |
|:----------- | ------------:| -----------:| ----:|
|Obs. Pos | $\dfrac{1460}{1502}=97.2\%$ | $\dfrac{42}{1502}=2.8\%$ | 1502 |
|Obs. Neg   | $\dfrac{31}{4920}=0.6\%$ | $\dfrac{4889}{4920}=99.4\%$ | 4920 |

----

# Sensitivity and Specificity

**Sensitivity**

- Another name for the True Positive Rate
- The proportion of correctly predicted positive observations

**Specificity**

- Another name for the True Negative Rate
- The proportion of correctly predicted negative observations

----

# Sensitivity and Specificity


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Pos </th>
   <th style="text-align:right;"> Pred. Neg </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:right;"> 1460 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:right;"> 2010 </td>
   <td style="text-align:right;"> 2910 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 3470 </td>
   <td style="text-align:right;"> 2952 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Pred. Pos </th>
   <th style="text-align:left;"> Pred. Neg </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:left;"> 97.2% </td>
   <td style="text-align:left;"> 2.8% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:left;"> 40.9% </td>
   <td style="text-align:left;"> 59.1% </td>
  </tr>
</tbody>
</table>

---

# Cohen's kappa

Cohen's kappa ($\kappa$) is a measure of agreement that rescales accuracy ($A$) to account for chance agreement ($P_e$):

$$\kappa = \frac{A - P_e}{1- P_e}$$

It can take values from $-\infty$ to 1, where 1 is perfect prediction and anything below zero is worse than chance.

----

# Cohen's kappa

Multiply proportions of observed and predicted to get probability of each outcome

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Pos </th>
   <th style="text-align:right;"> Pred. Neg </th>
   <th style="text-align:right;"> Sum </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:right;font-weight: bold;color: red !important;"> 1460 </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:right;color: black !important;"> 31 </td>
   <td style="text-align:right;"> 4889 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;color: black !important;"> 1491 </td>
   <td style="text-align:right;"> 4931 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>

$$P_{YY} = \frac{1491}{6422} \times \frac{1502}{6422} = 0.054$$

<!--
Example of calculation for one cell
-->

----

# Cohen's kappa

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pred. Pos </th>
   <th style="text-align:right;"> Pred. Neg </th>
   <th style="text-align:right;"> p </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs. Pos </td>
   <td style="text-align:right;"> 0.054 </td>
   <td style="text-align:right;"> 0.180 </td>
   <td style="text-align:right;"> 0.234 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Neg </td>
   <td style="text-align:right;"> 0.178 </td>
   <td style="text-align:right;"> 0.588 </td>
   <td style="text-align:right;"> 0.766 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:right;"> 0.232 </td>
   <td style="text-align:right;"> 0.768 </td>
   <td style="text-align:right;"> 1.000 </td>
  </tr>
</tbody>
</table>

$$
P_e = P_{YY} +  P_{NN} = 0.054 + 0.588 = 0.642
$$
$$
\kappa = \frac{0.989 - 0.642}{1- 0.642} = 0.969
$$

----

# True Skill Statistic

![Allouche 2016 w:900](images/Allouche_2016.png)

----

# True Skill Statistic

An alternative measure is TSS:

$$
\mbox{TSS} = \mbox{Sensitivity} + \mbox{Specificity} - 1
$$
$$
\mbox{TSS} = [0, 1] + [0, 1] - 1
$$

- TSS = 1 (perfect)
- TSS = 0 (random)
- TSS = -1 (always wrong)
- Unaffected by prevalence.

<!-- Simulation of thresholding -->
  


----

# Wait, no. Not TSS

![Wunderlich 2019 w:900](images/Wunderlich_2019.png)

<!--
TSS not useful when low prevalence and  large numbers (SDMs!)

- Odds Ratio Skill Score (ORSS)
- Symmetric Extremal Dependence Index (SEDI)
-->
---

# Probabilistic classification


<div class='columns21'>
<div>


![](figure/threshold-1.png)

</div>
<div>

A model predicting the probability of presence

</div>
</div>

----

# Threshold model

<div class='columns21'>
<div>

![](figure/threshold_0-1.png)

</div>
<div>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pr + </th>
   <th style="text-align:right;"> Pr - </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ob + </td>
   <td style="text-align:right;"> 54 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ob - </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>
<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

</div>
</div>

<!--
Switched column orders to match graph.
-->

----

# Threshold model

<div class='columns21'>
<div>

![](figure/threshold_0.25-1.png)

</div>
<div>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pr + </th>
   <th style="text-align:right;"> Pr - </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ob + </td>
   <td style="text-align:right;"> 54 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ob - </td>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
</tbody>
</table>
<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 1.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.543 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.543 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold model

<div class='columns21'>
<div>

![](figure/threshold_0.5-1.png)

</div>
<div>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pr + </th>
   <th style="text-align:right;"> Pr - </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ob + </td>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ob - </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 44 </td>
  </tr>
</tbody>
</table>
<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 0.870 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.957 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.827 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold model

<div class='columns21'>
<div>

![](figure/threshold_0.75-1.png)

</div>
<div>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pr + </th>
   <th style="text-align:right;"> Pr - </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ob + </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ob - </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 46 </td>
  </tr>
</tbody>
</table>
<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 0.463 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 1.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.463 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold model

<div class='columns21'>
<div>

![](figure/threshold_1_-1.png)

</div>
<div>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Pr + </th>
   <th style="text-align:right;"> Pr - </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ob + </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 54 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ob - </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 46 </td>
  </tr>
</tbody>
</table>
<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

</div>
</div>



----

# ROC Curve

<div class='columns'>
<div>

![](figure/thresh_plot3-1.png)

</div>
<div>

- Receiver operating characteristic (ROC)
- A random model gives the red line

</div>
</div>

----

# Area under ROC curve

<div class='columns'>
<div>

![](figure/thresh_plot4-1.png)

</div>
<div>

- Called AUC or AUROC
- AUC varies between 0 and 1
- AUC = 0.5 is random
- Threshold independent measure of overall model performance

</div>
</div>

<!-- SDM actual example  -->



---

# Species Distribution Models

<div class='columns'>
<div>

![w:500](images/kinkajou_596_600x450.jpg)
Kinkajou (*Potos flavus*)

</div>
<div>

![](figure/sdm_prob-1.png)

</div>
</div>

----

# Species Distribution Models

<div class='columns'>
<div>

![w:500](images/kinkajou_596_600x450.jpg)
Kinkajou (*Potos flavus*)

</div>
<div>

![](figure/sdm_prob2-1.png)

</div>
</div>



----

# Species Distribution Models

<div class='columns'>
<div>

![](figure/sdm_thresh1-1.png)

</div>
<div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Present </th>
   <th style="text-align:right;"> Absent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs </td>
   <td style="text-align:right;"> 200 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 158 </td>
   <td style="text-align:right;"> 42 </td>
  </tr>
</tbody>
</table><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.21 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Species Distribution Models

<div class='columns'>
<div>

![](figure/sdm_thresh2-1.png)

</div>
<div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Present </th>
   <th style="text-align:right;"> Absent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs </td>
   <td style="text-align:right;"> 188 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 107 </td>
   <td style="text-align:right;"> 93 </td>
  </tr>
</tbody>
</table><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 0.940 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.465 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.405 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Species Distribution Models

<div class='columns'>
<div>

![](figure/sdm_thresh3-1.png)

</div>
<div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Present </th>
   <th style="text-align:right;"> Absent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs </td>
   <td style="text-align:right;"> 77 </td>
   <td style="text-align:right;"> 123 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 45 </td>
   <td style="text-align:right;"> 155 </td>
  </tr>
</tbody>
</table><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 0.385 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.775 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.160 </td>
  </tr>
</tbody>
</table>

</div>
</div>



----

# AUC for the Kinkajou

<div class="columns21">
<div>

![](figure/kink_auc-1.png)

</div>
<div>

Maximum sensitivity + specificity shown in red.

</div>
</div>

----

# Species Distribution Models

<div class='columns'>
<div>

![](figure/sdm_thresh_mss-1.png)

</div>
<div>


<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Present </th>
   <th style="text-align:right;"> Absent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Obs </td>
   <td style="text-align:right;"> 198 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 114 </td>
   <td style="text-align:right;"> 86 </td>
  </tr>
</tbody>
</table><table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sens </td>
   <td style="text-align:right;"> 0.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.42 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold choices

<small>

| Method | Definition |
| --- | --- |
| Fixed value | Arbitrary fixed value |
| Lowest predicted value | The lowest predicted value corresponding with an observed occurrence record |
| Equal Sens Spec | The threshold at which sensitivity and specificity are equal |
| Max Sens + Spec | The sum of sensitivity and specificity is maximized |
| Maximize Kappa | The threshold at which Cohen's Kappa statistic is maximized |
| Equal prevalence | Propn of presences relative to the number of sites is equal in prediction and calibration data  |

</small>
