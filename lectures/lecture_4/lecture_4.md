---
title: Assessing model accuracy
author: David Orme
---

<!-- .slide: data-background-image="../shared_images/World3D_600.png"  data-background-position="right 10px bottom 20px"  data-background-size="40%" -->
# Assessing Model Accuracy

### David Orme




---

# Overview

  - The confusion matrix
  - Measures of model accuracy
  - Thresholds for continuous predictions
  - Application to Species Distribution Models

---

# MODIS land cover classification

![MODIS Confusion Matrix](images/MODIS_confusion_matrix.png)

Accuracy = 21906 / 29877 = 73.3%

----

# A simpler confusion matrix

Zoom in on just two of those categories:

<div class='vs'></div>

![](images/MODIS_confusion_matrix_zoom.png)

<div class='vs'></div>

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
   <td style="text-align:right;"> 740 </td>
   <td style="text-align:right;"> 762 </td>
   <td style="text-align:right;"> 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Obs. Broad </td>
   <td style="text-align:right;"> 2446 </td>
   <td style="text-align:right;"> 2474 </td>
   <td style="text-align:right;"> 4920 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sum </td>
   <td style="text-align:right;"> 3186 </td>
   <td style="text-align:right;"> 3236 </td>
   <td style="text-align:right;"> 6422 </td>
  </tr>
</tbody>
</table>

$$A = \frac{740 + 2474}{6422} = 50.0\%$$

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

<div class="leftpad">

Proportion of the observed positive outcomes

</div>

<div class="vs"></div>


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

Notes:

Switching to POS NEG

----

# Accuracy

<div class="leftpad">

And **accuracy is affected by prevalence**

</div>

<div class="vs"></div>


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

<div class="leftpad">

Giving some simple names to the four outcomes:

</div>
<div class="vs"></div>

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

<div class="leftpad">

Other more confusing names do get used:

</div>

<div class="vs"></div>


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

<div class="leftpad">

Divide the four outcomes by the **observed** positive and negative counts to give **rates**:

</div>

<div class="vs"></div>

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

<div class="leftpad">

Calculate those values:

</div>

<div class="vs"></div>

|	| Pred. Pos	| Pred. Neg	|  Sum	|
|:-----------	| ------------:|	-----------:|	----:|
|Obs. Pos	| $$\frac{1460}{1502}=97.2\%$$	| $$\frac{42}{1502}=2.8\%$$ | 1502	|
|Obs. Neg  	| $$\frac{31}{4920}=0.6\%$$	| $$\frac{4889}{4920}=99.4\%$$	| 4920	|

----

# Sensitivity and Specificity

**Sensitivity**

  - Another name for the True Positive Rate
  - The proportion of correctly predicted positive observations

<div class="vs"></div>

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

<div class="leftpad">

<div class='vs'></div>

</div>


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

<div class='leftpad'>

Cohen's kappa ($\kappa$) is a measure of agreement that rescales accuracy ($A$) to account for chance agreement ($P_e$):

</div>

$$\kappa = \frac{A - P_e}{1- P_e}$$

<div class='leftpad'>

It can take values from $-\infty$ to 1, where 1 is perfect prediction and anything below zero is worse than chance.

</div>

----

# Cohen's kappa

<div class='leftpad'>

Multiply proportions of observed and predicted to get probability of each outcome

</div>


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

Notes:
Example of calculation for one cell

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

![Allouche 2016](images/Allouche_2016.png)<!-- .element width="80%" -->

----

# True Skill Statistic

An alternative measure is TSS:

$$
\mbox{TSS} = \mbox{Sensitivity} + \mbox{Specificity} - 1
$$
$$
\mbox{TSS} = [0, 1] + [0, 1] - 1
$$

 * TSS = 1 (perfect)
 * TSS = 0 (random)
 * TSS = -1 (always wrong)
 * Unaffected by prevalence.

<!-- Simulation of thresholding -->
  


----

# Wait, no. Not TSS!

![Wunderlich 2019](images/Wunderlich_2019.png)

Notes:
TSS not useful when low prevalence and  large numbers (SDMs!)

* Odds Ratio Skill Score (ORSS) 
* Symmetric Extremal Dependence Index (SEDI)


---

# Probabilistic classification

A model predicting the </br> probability of success / presence

![](figure/threshold-1.png)

----

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0-1.png)


</div>

<div class='col1'>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 0 </th>
   <th style="text-align:right;"> 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 50 </td>
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

Notes:
Switched column orders to match graph.

----

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0.25-1.png)
</div>

<div class='col1'>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 0 </th>
   <th style="text-align:right;"> 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 47 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 28 </td>
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
   <td style="text-align:right;"> 0.94 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.44 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.38 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0.5-1.png)
</div>

<div class='col1'>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 0 </th>
   <th style="text-align:right;"> 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:right;"> 15 </td>
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
   <td style="text-align:right;"> 0.74 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.70 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.44 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0.75-1.png)
</div>

<div class='col1'>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 0 </th>
   <th style="text-align:right;"> 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:right;"> 4 </td>
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
   <td style="text-align:right;"> 0.42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.92 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.34 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_1_-1.png)
</div>

<div class='col1'>

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> 0 </th>
   <th style="text-align:right;"> 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 50 </td>
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

<div class='container'>
<div class='col2'>

![](figure/thresh_plot3-1.png)

</div>
<div class='col1'>

* Receiver operating characteristic (ROC)
* A random model gives the red line

</div>
</div>

----

# Area under ROC curve (AUC)

<div class='container'>
<div class='col2'>

![](figure/thresh_plot4-1.png)

</div>
<div class='col1'>

  - AUC varies between 0 and 1.
  - AUC = 0.5 is random.
  - Overall model performance

</div>
</div>

<!-- SDM actual example  -->



---

# Species Distribution Models

<div class='container'>
<div class='col1'>

![](images/kinkajou_596_600x450.jpg)
Kinkajou (*Potos flavus*)

</div>
<div class='col1'>

![](figure/sdm_prob-1.png)

</div>
</div>

----

# Species Distribution Models

<div class='container'>
<div class='col1'>

![Kinkajou (*Potos flavus*)](images/kinkajou_596_600x450.jpg)

* Observed (red)
* Background (black)

</div>
<div class='col1'>

![](figure/sdm_prob2-1.png)

</div>
</div>





----

# Species Distribution Models

<div class='container'>
<div class='col1'>
    
![](figure/sdm_thresh1-1.png)

</div>
<div class='col1'>

Threshold = 0.1


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
   <td style="text-align:right;"> 162 </td>
   <td style="text-align:right;"> 38 </td>
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
   <td style="text-align:right;"> 0.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 1.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.19 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Species Distribution Models

<div class='container'>
<div class='col1'>

![](figure/sdm_thresh2-1.png)

</div>
<div class='col1'>

Threshold = 0.4

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
   <td style="text-align:right;"> 187 </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 111 </td>
   <td style="text-align:right;"> 89 </td>
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
   <td style="text-align:right;"> 0.445 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.935 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.380 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Species Distribution Models

<div class='container'>
<div class='col1'>
    
![](figure/sdm_thresh3-1.png)

</div>
<div class='col1'>

Threshold = 0.55

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
   <td style="text-align:right;"> 67 </td>
   <td style="text-align:right;"> 133 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 163 </td>
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
   <td style="text-align:right;"> 0.815 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.335 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.150 </td>
  </tr>
</tbody>
</table>

</div>
</div>



----

# AUC for the Kinkajou

Maximum sensitivity + specificity shown in red.

![](figure/kink_auc-1.png)

----

# Species Distribution Models

<div class='container'>
<div class='col1'>
    
![](figure/sdm_thresh_mss-1.png)

</div>
<div class='col1'>

<center>Threshold = 0.411</center>

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
   <td style="text-align:right;"> 183 </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Back </td>
   <td style="text-align:right;"> 106 </td>
   <td style="text-align:right;"> 94 </td>
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
   <td style="text-align:right;"> 0.470 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spec </td>
   <td style="text-align:right;"> 0.915 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TSS </td>
   <td style="text-align:right;"> 0.385 </td>
  </tr>
</tbody>
</table>

</div>
</div>

----

# Threshold choices

<div style='font-size: 20pt'>

| Method | Definition |
| --- | --- |
| Fixed value | An arbitrary fixed value (e.g. probability = 0.5) |
| Lowest predicted value | The lowest predicted value corresponding with an observed occurrence record |
| Sensitivity-specificity equality | The threshold at which sensitivity and specificity are equal |
| Sensitivity-specificity sum maximization | The sum of sensitivity and specificity is maximized |
| Maximize Kappa | The threshold at which Cohen’s Kappa statistic is maximized |
| Equal prevalence | Propn of presences relative to the number of sites is equal in prediction and calibration data  | 

</div>

