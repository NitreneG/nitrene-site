---
title: POVM -- Generalized Quantum Measurement
published: 2026-09-24
pinned: false
description: 
    POVMs extend the concept of quantum state measurement, laying the foundation for quantum computing and information processing.

tags: ["Quantum Information", "Quantum Measurement", "Quantum Computing"]
category: Essay
image: ./images/articles/POVM/1.jpeg
slug: General-Quantum-Measurement
---
As a fundamental concept in quantum information, a positive
operator-valued measure (POVM) extends the traditional projective
description of quantum measurement. Its simple but beautiful
mathematical structure provides a general language for describing
measurement statistics and information extraction. In this article, we try to give a brief introduction to POVMs, and gain some insights into the modern measurement theory. 

# Measure
A POVM is an operator-valued analogue of an ordinary probability measure. A positive **Measure** $\mu$ is  a map defined on a measurable space
$$
\begin{aligned}
    (\Omega, \Sigma)
\end{aligned}
$$
 
where $\Omega$ is the sample space and $\Sigma$ is the $\sigma$-algebra of measurable subsets of $\Omega$. 
$$
\begin{aligned}
    \mu: \Sigma \to [0, +\infty]
\end{aligned}
$$

satisfying the following properties:
- $\mu(\emptyset) = 0$
- For any sequence of disjoint sets $\{A_n\}_{n=1}^{\infty} \subset \Sigma$, we have
  $$
  \mu\left(\bigcup_{n=1}^{\infty} A_n\right) = \sum_{n=1}^{\infty} \mu(A_n)
  $$

A POVM generalizes an ordinary measure by replacing nonnegative real values with positive semidefinite operators.

$$
\begin{aligned}
    E : \Sigma \to \mathcal{B}(\mathcal{H})_+
\end{aligned}
$$

where $\mathcal{B}(\mathcal{H})_+$ is the set of positive semi-definite bounded operators, $\{E_m\}$ is the set of positive semi-definite operators on a Hilbert space $\mathcal{H}$, satisfying the following properties:

- $E(\bigcup_{m} A_m) = \sum_{m} E(A_m)$ for any disjoint sets $\{A_m\}_{m=1}^{\infty} \subset \Sigma$
- $E(\Omega) = I$

Given a quantum state $\rho$, the POVM induces an ordinary probability
measure, specifies the statistics of the measurement outcomes

$$p(m) = Tr(E_m \rho)$$

where $\rho$ is the density matrix of any quantum state in $\mathcal{H}$



# Measurement

With the above definition, a POVM may initially look like nothing more
than a set of operators used to calculate outcome probabilities. But
traditional quantum mechanics already describes measurement using
Hermitian observables and projectors. What, then, does a POVM add? Now let's talk about the **Measurement** to see the difference.

## Classical to Quantum Measurement

Built on classical mechanics and probability theory, one of the main topics of classical measurement is "determinism". In practice, a system is described by a physical theory in these 3 aspects
- State (what is it)
- Dynamics (how it evolves)
- Measurement (how to observe)

Classical Mechanics tells us that  Newton's laws give the deterministic path. Measurement is just revealing pre-existing properties. An ideal measurement reads out a property without necessarily changing it.

Quantum Mechanics does not only change the way we describe the state and dynamics, but also add a new bond to the measurement. The outcome of a measurement is an intrinsically probabilistic event. A quantum measurement can also change the state, and the state update depends on how the measurement is physically implemented.

The observable can be described as the sum of projectors $P$ with the eigenvalue $o_m$ (spectral decomposition):

$$
\begin{aligned}
    \hat{O} = \sum_{m} o_m P_m
\end{aligned}
$$

for a state expanded  in the eigenbasis $\phi = \sum_{m} c_m \psi_m$, 
where
$$
\begin{aligned}
    \hat{O} \psi_m = o_m \psi_m
\end{aligned}
$$

Suppose we perform a non-degenerate projective measurement and obtain the outcome $o_m$. Conditioned on this outcome, the state is updated to the corresponding eigenstate $\ket{\psi_m}$. This is the usual measurement “collapse”.

It is useful to distinguish this conditioned state update from decoherence. If the measurement is performed but its outcome is ignored, the state is instead described by

$$
\rho \longrightarrow \sum_i P_i \rho P_i,
$$

which removes the coherence between different measurement eigenspaces. The decoherence changes the way we detect the state and decode the Quantum furnished information. 

## General Quantum Measurement

A projective measurement is described by mutually orthogonal
projectors. A POVM relaxes this requirement: its effects only need to
be positive and complete, and they need not be orthogonal or
idempotent.

It is allowed that

- non-orthogonal
    $$
    \begin{aligned}
        E_m E_n \neq 0, \quad m \neq n
    \end{aligned}
    $$

- non-projective
    $$
    \begin{aligned}
        E_m^2 \neq E_m
    \end{aligned}
    $$
but it is still 
- Complete
    $$
    \begin{aligned}
        \sum_{m} E_m = I
    \end{aligned}
    $$

for example we have an  inefficient detector, it cannot always detect the "occurrence" $\ket1$ when it really happens.

$$
\begin{aligned}
    E_1 &= \eta |1\rangle\langle 1|  \\
    E_0 &= |0\rangle\langle 0|  + (1-\eta) |1\rangle\langle 1| \\
\end{aligned}
$$

So we can construct any number of POVMs to describe the measurement, not limited by the dimension of the Hilbert space. 
A POVM on a $d$-dimensional system may have more than $d$ outcomes.


# Detection
Having defined POVMs mathematically, a natural question remains: can every valid POVM be physically realized? Naimark's dilation theorem answers this question affirmatively. In fact, any POVMs can be realized by a projective measurement with an auxiliary system. **Naimark's Dilation Theorem** states the following:

For every POVM $\{E_m\}$ on a Hilbert space $\mathcal{H}_S$, satisfying
$$
\begin{aligned}
    \sum_{m} E_m = I_s \\
    E_m \geq 0
\end{aligned}
$$

there exists an ancilla $\mathcal{H}_A$, an initial ancilla state $\ket{0}_A$, a unitary operator $U$ on $\mathcal{H}_S \otimes \mathcal{H}_A$, and a set of projectors $\{\Pi_m\}$ 

such that
$$
\begin{aligned}
    Pr(m|\rho) = Tr(E_m \rho) = Tr(\Pi_m U (\rho \otimes |0\rangle_A \langle 0|) U^\dagger)
\end{aligned}
$$

This looks like:

- we have our $E_m \in Hom(\mathcal{H}_S)$
- the embedding operator $J: \mathcal{H}_S \to \mathcal{H}_S \otimes \mathcal{H}_A$ appends an ancilla in the state $|0\rangle_A$.
- We take an unitary $U \in Hom(\mathcal{H}_S \otimes \mathcal{H}_A)$ to transform the state. So $V = UJ$ is an isometry, and we have $E_m = V^\dagger \Pi_m V$.

- We perform a projective measurement on the larger tensor-product space, and get the same  outcome statistics.


Every POVM can be regarded as a projective measurement after embedding the system into a larger Hilbert space. 

## Example: the trine POVM
There are 3 nonzero effects $E_0, E_1, E_2$ given by
$$
\begin{aligned}
    E_k = \frac{1}{3} (I + \mathbf{n}_k \cdot \boldsymbol{\sigma})= \frac{2}{3} |\psi_k\rangle\langle\psi_k|, \quad k = 0, 1, 2
\end{aligned}
$$
and the quantum states are given by
$$
\begin{aligned}
    |\psi_k\rangle = \frac{1}{\sqrt{2}} (|0\rangle + e^{i \theta_k} |1\rangle), \quad \theta_k = \frac{2\pi}{3} k
\end{aligned}
$$
which are not orthogonal to each other. With an input state $\ket{\psi}$, we have the probability of the outcome $k$ as
$$
\begin{aligned}
    Pr(k|\psi) = Tr(E_k |\psi\rangle\langle\psi|) = \frac{2}{3} |\langle\psi_k|\psi\rangle|^2
\end{aligned}
$$


If outcome $k$ is interpreted as the guess that the input was
$|\psi_k\rangle$, the measurement does not identify the state
perfectly because the trine states are nonorthogonal.

Naimark's dilation works when we take an ancilla $\mathcal{H}_A = \text{span}\{|0\rangle_A, |1\rangle_A, |2\rangle_A\}$ 
where ${}_A\langle j|k\rangle_A=\delta_{jk}$

we choose the measurement operators (not unique) to build the isometry
$$
\begin{aligned}
    M_k = \sqrt{E_k} = \sqrt{\frac{2}{3}} |\psi_k\rangle\langle\psi_k|
\end{aligned}
$$

and the isometry $V: \mathcal{H}_S \to \mathcal{H}_S \otimes \mathcal{H}_A$ is given by
$$
\begin{aligned}
    V \ket{\psi}_S &= \sum_{k=0}^{2} M_k \ket{\psi}_S \otimes |k\rangle_A \\
    &= \sqrt{\frac{2}{3}} \sum_{k=0}^{2} |\psi_k\rangle\langle\psi_k|\psi\rangle_S \otimes |k\rangle_A
\end{aligned}
$$

easy to verify that
$$
\begin{aligned}
    V^\dagger V  &= \sum_k M_k^\dagger M_k  \\
    &= \sum_k  E_k  = I_S
\end{aligned}
$$

via the isometry, the projective measurement can be performed on the larger space

$$
\begin{aligned}
    \Pi_k = I_S \otimes |k\rangle \langle k|_A \\
    E_k = V^\dagger \Pi_k V = M_k^\dagger M_k
\end{aligned}
$$

With the orthogonal outcome branches, we can measure the ancilla projectively

$$
\begin{aligned}
    p(k|\psi) = ||(I_S \otimes \langle k|_A) V \ket{\psi}_S ||^2 = \bra{\psi} M_k^\dagger M_k \ket{\psi} = \bra{\psi} E_k \ket{\psi}
\end{aligned}
$$

POVMs are the **Natural** language for optimal quantum measurement. If we have prepared one of the several possible states, it's necessary to choose the best measurement to distinguish them. 


# Discrimination --I want/I don't know?

Uncertainty lies at the heart of quantum information.You prepare a quantum state to store information, but you don't exactly know which one it is. You receive the state, and you perform a projective measurement through the Naimark's dilation, but you may still be not sure if it is a "0" or "1". Quantum Mechanically, two non-orthogonal states cannot be perfectly distinguished.


$$
\begin{aligned}
    0< |\langle\psi_1|\psi_2\rangle| < 1
\end{aligned}
$$

We therefore face a choice. We may always make a guess and minimize the
error probability, or we may forbid erroneous conclusive answers while
allowing an inconclusive result.


## Minimum Error Discrimination

---
Always make a guess. -- I want an answer, even if you are lying.

---
        
### Binary minimum error discrimination

Sample: $S=\{p_0, \rho_0; p_1, \rho_1\}$, with  POVMs $\{E_0, E_1\}$
the success/error probability 
$$
\begin{aligned}
    P_{succ}&= p_0 Tr(E_0 \rho_0) + p_1 Tr(E_1 \rho_1)  \\
    P_{err}&= 1- P_{succ} \\
    p_0 + p_1 &= 1, \quad E_0 + E_1 = I
\end{aligned}
$$
the Helstrom operator $\Delta = p_0 \rho_0 - p_1 \rho_1$ then,
$$
\begin{aligned}
    P_{succ}&= p_0 \text{Tr}(E_0 \rho_0) + p_1 \text{Tr}((I-E_0) \rho_1) \\
    &= p_1 + Tr(E_0 \Delta) \\
\end{aligned}
$$
what we need to do is to maximize $Tr(E_0 \Delta)$ by choosing the optimal $E_0$. We can spectral decompose the Helstrom operator.

$$
\begin{aligned}
    \Delta = \sum_{k} \lambda_k |  k\rangle\langle k|
\end{aligned}
$$

take a direct sum decomposition of the eigenspaces of $\Delta$ into positive and negative subspaces

$$
\begin{aligned}
    \Delta &= \Delta_+ - \Delta_- \\
    &= \sum_{\lambda_k > 0} \lambda_k |k\rangle\langle k| + \sum_{\lambda_k < 0} \lambda_k |k\rangle\langle k| \\
    |\Delta| &= \Delta_+ + \Delta_-  \\
    \text{where} \quad  \Delta_+ &= \sum_{\lambda_k > 0} \lambda_k |k\rangle\langle k| \\
    \Delta_- &= -\sum_{\lambda_k < 0} \lambda_k |k\rangle\langle k| \\
\end{aligned}
$$

Since $0\leq E_0\leq I$, the maximum is obtained by assigning eigenvalue one to the positive eigenspace of $\Delta$ and zero to its negative eigenspace.
$$
\begin{aligned}
    E_0 &= \Pi_{+}(\Delta) \\
    E_1 &= I - E_0 
\end{aligned}
$$
So we have the **Helstrom measurement**

$$
\begin{aligned}
    \max_{0\leq E_0 \leq I} Tr(E_0 \Delta) = Tr(\Delta_+)
\end{aligned}
$$

So the optimal success probability is
$$
\begin{aligned}
    P_{succ}^{opt} = p_1 + Tr(\Delta_+) = \frac{1}{2} (1 + ||\Delta||_1) = \frac{1}{2} (1 + \sum_i |\lambda_i| ) \\
    P_{err}^{opt} = 1 - P_{succ}^{opt} = \frac{1}{2} (1 - ||\Delta||_1) = \frac{1}{2} (1 - \sum_i |\lambda_i| )
\end{aligned}
$$

**Helstrom Bounds**

for the equal prior $p_0 = p_1 = \frac{1}{2}$
$$
\begin{aligned}
    P_{err}^{opt} = \frac{1}{2} (1 - D(\rho_0, \rho_1))
\end{aligned}
$$
where $D$ is  the trace distance  defined as
$$
\begin{aligned}
    D(\rho, \sigma) = \frac{1}{2} ||\rho - \sigma||_1
\end{aligned}
$$


Suppose we have 2 pure states $\ket{\psi_0}$ and $\ket{\psi_1}$, the error rate becomes
$$
\begin{aligned}
    P_{err}^{opt} = \frac{1}{2} (1 - \sqrt{1 - |\langle\psi_0|\psi_1\rangle|^2})
\end{aligned}
$$

For binary minimum-error discrimination, optimizing over all POVMs yields an optimal projective measurement (PVM): The Helstrom measurement. 



## Unambiguous  discrimination

---
Never make a wrong conclusive guess. -- I don't know.

---



$E_0+E_1+E_?=I$ 
we allow an inconclusive outcome $E_?$ to avoid the error. We are sure that if we get the outcome $E_0$ or $E_1$
$$
\begin{aligned}
    Tr(E_0 \rho_1) = Tr(E_1 \rho_0) = 0
\end{aligned}
$$

The success probability to be optimized is
$$
\begin{aligned}
    P_{succ} = \eta_0 Tr(E_0 \rho_0) + \eta_1 Tr(E_1 \rho_1)
\end{aligned}
$$

The Unambiguous State Discrimination (USD) requires:
$$
\begin{aligned}
    \bra{\psi_0} E_1 \ket{\psi_0} = 0, \quad \bra{\psi_1} E_0 \ket{\psi_1} = 0
\end{aligned}
$$
Suppose $\eta_0 = \eta_1 = \frac{1}{2}$, for 2 pure states $\ket{\psi_0}$ and $\ket{\psi_1}$, which are not orthogonal to each other. we can choose the basis $\ket{0}, \ket{1}$ such that

$$
\begin{aligned}
    \ket{\psi_0} = \ket{0}, \quad \ket{\psi_1} = c\ket{0} + s \ket{1}
\end{aligned}
$$
choose their orthogonal complements
$$
\begin{aligned}
    \ket{\psi_0^\perp} = \ket{1}, \quad \ket{\psi_1^\perp} = s\ket{0} - c\ket{1}
\end{aligned}
$$
then we can construct the POVMs as

$$
\begin{aligned}
    E_0 &= a \ket{\psi_1^\perp}\bra{\psi_1^\perp} \\
    E_1 &= a \ket{\psi_0^\perp}\bra{\psi_0^\perp} \\
    E_? &= I - E_0 - E_1 = \begin{pmatrix}
    1 - as^2 & asc\\
    asc & 1 - a(1 + c^2)
    \end{pmatrix}
\end{aligned}
$$

For $E_?$ to be positive semidefinite, its principal minors must be non-negative. Together with $a\geq0$, the limiting determinant condition gives 
$$
\begin{aligned}
    \det(E_?) &= (1 - as^2)(1 - a(1 + c^2)) - (asc)^2 \geq 0 \\
    a &\leq \frac{1}{1 + c} 
\end{aligned}
$$

So we have the Ivanovic-Dieks-Peres (IDP) limit
$$
\begin{aligned}
    P_{succ}^{USD} = a_{max}(1-c^2) = 1 - c = 1 - |\langle\psi_0|\psi_1\rangle|
\end{aligned}
$$

# Conclusion
POVMs extend projective measurements by allowing outcome effects that need not be orthogonal projectors. Naimark dilation shows that these generalized measurement statistics can be realized by coupling the system to an ancilla and projectively reading orthogonal pointer states. In state discrimination, the choice of POVM determines how we trade errors against inconclusive results. Quantum measurement is therefore not merely the reading of an eigenvalue, but a physically constrained way of extracting classical information from a quantum state.


Quantum information is about what can be learned from quantum states,
and the laws of quantum measurement impose fundamental limits on
information extraction.

References:

<span id="ref-1"></span>1. M. A. Nielsen and I. L. Chuang, *Quantum Computation and Quantum Information*, 10th anniversary ed., Cambridge University Press (2010).

<span id="ref-2"></span>2. C. W. Helstrom, *Quantum Detection and Estimation Theory*, Academic Press (1976).

<span id="ref-3"></span>3. A. S. Holevo, *Probabilistic and Statistical Aspects of Quantum Theory*, North-Holland (1982).

<span id="ref-4"></span>4. A. Chefles, “Quantum State Discrimination,” *Contemporary Physics* **41**, 401–424 (2000), DOI: [10.1080/00107510010002599](https://doi.org/10.1080/00107510010002599).

<span id="ref-5"></span>5. S. M. Barnett and S. Croke, “Quantum State Discrimination,” *Advances in Optics and Photonics* **1**, 238–278 (2009), DOI: [10.1364/AOP.1.000238](https://doi.org/10.1364/AOP.1.000238).

<span id="ref-6"></span>6. Quantum Information Lecture, Prof. J.Y.Fan, Department of Physics, SUSTech.

![ILLIT_Minju](./images/articles/POVM/2.jpeg)
