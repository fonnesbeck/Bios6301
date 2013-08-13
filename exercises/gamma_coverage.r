true_alpha <- 5
true_beta <- 7

N <- 1000

lower_a <- numeric(N)
upper_a <- numeric(N)
lower_b <- numeric(N)
upper_b <- numeric(N)

for (j in 1:N) {
    
    # Data sample
    x <- rgamma(100, true_alpha, true_beta)
    R <- 999

    alphas <- numeric(R)
    betas <- numeric(R)

    for (i in 1:R) {

        # Bootstrap sample
        s <- x[sample(length(x), replace=TRUE)]
        # Estimators for alpha and beta
        alphas[i] <- (mean(s)/sd(s))^2
        betas[i] <- mean(s)/var(s)
    
    }

    # Sort and extract percentles
    alphas_sorted = sort(alphas)
    betas_sorted = sort(betas)

    lower_a[j] <- alphas_sorted[(R+1)*0.025]
    upper_a[j] <- alphas_sorted[(R+1)*0.975]
    lower_b[j] <- betas_sorted[(R+1)*0.025]
    upper_b[j] <- betas_sorted[(R+1)*0.975]
}

print(mean(lower_a < true_alpha & upper_a > true_alpha))
print(mean(lower_b < true_beta & upper_b > true_beta))