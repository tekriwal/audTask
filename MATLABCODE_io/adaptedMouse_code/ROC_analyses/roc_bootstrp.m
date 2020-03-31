% wrapper function for bootstrp routine

function f = roc_bootstrp(X,grps,initial_solution,nulldist)
        
    f = roc_sv(X,grps,'nofigure');