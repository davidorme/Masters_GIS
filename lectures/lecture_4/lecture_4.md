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

<center>Accuracy = 21906 / 29877 = 73.3%</center>

---

# A simpler confusion matrix

Zoom in on just two of those categories:
 
 
![](images/MODIS_confusion_matrix_zoom.png)

Model predicts: Is this evergreen forest needleleaf or broadleaf




---

# Accuracy

<div class="leftpad">

Easy to calculate **accuracy**:

</div>

<div class="vs"></div>


|            | Pred. Needle| Pred. Broad|  Sum|
|:-----------|------------:|-----------:|----:|
|Obs. Needle |         1460|          42| 1502|
|Obs. Broad  |           31|        4889| 4920|
|Sum         |         1491|        4931| 6422|

$$A = \frac{1460 + 4889}{1460 + 4889 + 42 +31} = 98.9\%$$

---

# Accuracy

<div class="leftpad">

But **random** models can have reasonable accuracy!

</div>

<div class="vs"></div>


|            | Pred. Needle| Pred. Broad|  Sum|
|:-----------|------------:|-----------:|----:|
|Obs. Needle |          756|         746| 1502|
|Obs. Broad  |         2441|        2479| 4920|
|Sum         |         3197|        3225| 6422|

$$A = \frac{756 + 2479}{6422} = 50.4\%$$

---

# Accuracy

<div class="leftpad">

And so can stupid ones: **everything is a broadleaf**.

</div>

<div class="vs"></div>


|            | Pred. Needle| Pred. Broad|  Sum|
|:-----------|------------:|-----------:|----:|
|Obs. Needle |            0|        1502| 1502|
|Obs. Broad  |            0|        4920| 4920|
|Sum         |            0|        6422| 6422|

$$A = \frac{0 + 4920}{6422} = 76.6\%$$

---

# Prevalence

<div class="leftpad">

**Prevalence** is simple the proportion of the observed positive outcomes:

</div>

<div class="vs"></div>

$$\mbox{Prevalence} = \frac{1502 }{6422} = 0.234$$

---

# Accuracy

<div class="leftpad">

And **accuracy is affected by prevalence**

</div>

<div class="vs"></div>


|            | Pred. Needle| Pred. Broad|  Sum|
|:-----------|------------:|-----------:|----:|
|Obs. Needle |            0|          35|   35|
|Obs. Broad  |            0|        6407| 6407|
|Sum         |            0|        6442| 6442|

$$A = \frac{0 + 6407}{6422} = 99.5\%$$

---

# Prediction outcomes

<div class="leftpad">

Giving some simple names to the four outcomes:

</div>

<div class="vs"></div>


|            |   Pred. Needle    |    Pred. Broad    |
|:-----------|:-----------------:|:-----------------:|
|Obs. Needle | True<br>Positive  | False<br>Negative |
|Obs. Broad  | False<br>Positive | True<br>Negative  |

---

# Prediction outcomes

<div class="leftpad">

Other more confusing names do get used:

</div>

<div class="vs"></div>



|            |   Pred. Needle   |   Pred. Broad    |
|:-----------|:----------------:|:----------------:|
|Obs. Needle | True<br>Positive | Type II<br>Error |
|Obs. Broad  | Type I<br>Error  | True<br>Negative |

---

# Rates of outcomes

<div class="leftpad">

Divide the four outcomes by the **observed** positive and negative counts to give **rates**:

</div>

<div class="vs"></div>


|            |       Pred. Needle        |        Pred. Broad        |
|:-----------|:-------------------------:|:-------------------------:|
|Obs. Needle | True<br>Positive<BR>Rate  | False<br>Negative<BR>Rate |
|Obs. Broad  | False<br>Positive<BR>Rate | True<br>Negative<BR>Rate  |

---

# Rates of outcomes

<div class="leftpad">

Calculate those values:

</div>

<div class="vs"></div>

|	| Pred. Needle	| Pred. Broad	|  Sum	|
|:-----------	| ------------:|	-----------:|	----:|
|Obs. Needle	| $$\frac{1460}{1502}=97.2\%$$	| $$\frac{42}{1502}=2.8\%$$ | 1502	|
|Obs. Broad  	| $$\frac{31}{4920}=0.6\%$$	| $$\frac{4889}{4920}=99.4\%$$	| 4920	|

---

# Sensitivity and Specificity

**Sensitivity**

  - Another name for the True Positive Rate
  - The proportion of correctly predicted positive observations

<div class="vs"></div>

**Specificity**

  - Another name for the True Negative Rate
  - The proportion of correctly predicted negative observations

---

# Sensitivity and Specificity


|            | Pred. Needle| Pred. Broad|  Sum|
|:-----------|------------:|-----------:|----:|
|Obs. Needle |         1460|          42| 1502|
|Obs. Broad  |         2010|        2910| 4920|
|Sum         |         3470|        2952| 6422|

<div class="leftpad">

Outcome rates for the new model above

</div>


|            |Pred. Needle |Pred. Broad |
|:-----------|:------------|:-----------|
|Obs. Needle |97.2%        |2.8%        |
|Obs. Broad  |40.9%        |59.1%       |

---

# Cohen's kappa

<div class='leftpad'>

Cohen's kappa ($\kappa$) is a measure of agreement that rescales accuracy ($A$) to account for chance agreement ($P_e$):

</div>

$$\kappa = \frac{A - P_e}{1- P_e}$$

<div class='leftpad'>

It can take values from $-\infty$ to 1, where 1 is perfect prediction and anything below zero is worse than chance.

</div>

---

# Cohen's kappa

<div class='leftpad'>

Multiply proportions of observed and predicted to get probability of each outcome

</div>



|            | Pred. Needle| Pred. Broad|  Sum|
|:-----------|------------:|-----------:|----:|
|Obs. Needle |         1460|          42| 1502|
|Obs. Broad  |           31|        4889| 4920|
|Sum         |         1491|        4931| 6422|

$$P_{YY} = \frac{1491}{6422} \times \frac{1502}{6422} = 0.054$$

---

# Cohen's kappa


|            | Pred. Needle| Pred. Broad|     p|
|:-----------|------------:|-----------:|-----:|
|Obs. Needle |        0.054|       0.180| 0.234|
|Obs. Broad  |        0.178|       0.588| 0.766|
|p           |        0.232|       0.768| 1.000|

$$
P_e = P_{YY} +  P_{NN}
\kappa = \frac{0.989 - (0.054 + 0.588)}{1- (0.054 + 0.588)} = 0.969
$$

---

# True Skill Statistic

TODO - MathJax linebreak fix?

An alternative measure is TSS:

$$
\mbox{TSS} = \mbox{Sensitivity} + \mbox{Specificity} - 1\\
\mbox{TSS} = [0, 1] + [0, 1] - 1
$$

 * TSS = 1 (perfect)
 * TSS = 0 (random)
 * TSS = -1 (always wrong)
 * Unaffected by prevalence.

<!-- Simulation of thresholding -->
  


---

# Threshold model

A model predicting the probability of success.

![](figure/threshold-1.png)

---

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0-1.png)
</div>

<div class='col1'>


|   |  0|  1|
|:--|--:|--:|
|1  |  0| 59|
|0  |  0| 41|


|     | value|
|:----|-----:|
|Sens |     1|
|Spec |     0|
|TSS  |     0|

</div>
</div>

---

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0.25-1.png)
</div>

<div class='col1'>


|   |  0|  1|
|:--|--:|--:|
|1  |  2| 57|
|0  | 19| 22|


|     | value|
|:----|-----:|
|Sens | 0.966|
|Spec | 0.463|
|TSS  | 0.430|

</div>
</div>

---

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0.5-1.png)
</div>

<div class='col1'>


|   |  0|  1|
|:--|--:|--:|
|1  | 10| 49|
|0  | 35|  6|


|     | value|
|:----|-----:|
|Sens | 0.831|
|Spec | 0.854|
|TSS  | 0.684|

</div>
</div>

---

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_0.75-1.png)
</div>

<div class='col1'>


|   |  0|  1|
|:--|--:|--:|
|1  | 30| 29|
|0  | 40|  1|


|     | value|
|:----|-----:|
|Sens | 0.492|
|Spec | 0.976|
|TSS  | 0.467|

</div>
</div>

---

# Threshold model

<div class='container'>
<div class='col2'>

![](figure/threshold_1_-1.png)
</div>

<div class='col1'>


|   |  0|  1|
|:--|--:|--:|
|1  | 59|  0|
|0  | 41|  0|


|     | value|
|:----|-----:|
|Sens |     0|
|Spec |     1|
|TSS  |     0|

</div>
</div>




---

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

---

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

---

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





---

# Species Distribution Models

<div class='container'>
<div class='col1'>
	
![](figure/sdm_thresh1-1.png)

</div>
<div class='col1'>

Threshold = 0.1


|     | Present| Absent|
|:----|-------:|------:|
|Obs  |     200|      0|
|Back |     159|     41|

|     | value|
|:----|-----:|
|Sens | 0.205|
|Spec | 1.000|
|TSS  | 0.205|

</div>
</div>

---

# Species Distribution Models

<div class='container'>
<div class='col1'>

![](figure/sdm_thresh2-1.png)

</div>
<div class='col1'>

Threshold = 0.4

|     | Present| Absent|
|:----|-------:|------:|
|Obs  |     186|     14|
|Back |     121|     79|

|     | value|
|:----|-----:|
|Sens | 0.395|
|Spec | 0.930|
|TSS  | 0.325|

</div>
</div>

---

# Species Distribution Models

<div class='container'>
<div class='col1'>
	
![](figure/sdm_thresh3-1.png)

</div>
<div class='col1'>

Threshold = 0.55

|     | Present| Absent|
|:----|-------:|------:|
|Obs  |      80|    120|
|Back |      51|    149|

|     | value|
|:----|-----:|
|Sens | 0.745|
|Spec | 0.400|
|TSS  | 0.145|

</div>
</div>



---

# AUC for the Kinkajou

<center>Maximum sensitivity + specificity shown in red.</center>

![](figure/kink_auc-1.png)

---

# Species Distribution Models

<div class='container'>
<div class='col1'>
	
![](figure/sdm_thresh_mss-1.png)

</div>
<div class='col1'>

<center>Threshold = 0.371</center>

|     | Present| Absent|
|:----|-------:|------:|
|Obs  |     195|      5|
|Back |     126|     74|

|     | value|
|:----|-----:|
|Sens | 0.370|
|Spec | 0.975|
|TSS  | 0.345|

</div>
</div>

---

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

---

# Fast moving field

<iframe src='https://natureconservation.pensoft.net/article/33918/' width='100%' height='500px'>

