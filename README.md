# svm_demo
Demonstrate SVM for 3 different datasets

Created as part of a demo for STAT 4400 (Statistical Machine Learning) at Columbia. I demonstrate building SVMs on 3 different datasets in R. This is designed in order to begin with the simplest dataset, Cities, then the more complicated Weddings, then finally EVA. 

### Requirements

This demo requires the `e1071` and `ggplot2` packages. 


### Cities

The cities data is a nice clear 2 dimensional dataset. There are two sets of labels dividing cities into Developing vs Developed countries. One is based on an informal approximation, the other is the CIA's official definition of Developing vs Developed. The informal definition is linearly separable. The formal one is not quite separable, but a soft margin linear SVM does a good job.


### Wedding

This next dataset comes from the New York Times' wedding announcements. We filter it to only try to predict binary wise, is the bride likely to change her name based on the ages of the bride and groom. When visualized with jitter it's clear this is a tricky problem. The best an SVM can do is suggest that older couples are less likely to change their names.

### EVA

This is a fun dataset that's yields to pretty good prediction, but you need a non-linear boundary. SVM with an RBF kernel works great!
