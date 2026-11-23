# The Unmeasured Remainder

[![verify](https://github.com/Bardakor/The-Unmeasured-Remainder/actions/workflows/verify.yml/badge.svg)](https://github.com/Bardakor/The-Unmeasured-Remainder/actions/workflows/verify.yml)

**[Read the paper (PDF)](The-Unmeasured-Remainder.pdf)**, compiled from
[`paper-unmeasured/main.tex`](paper-unmeasured/main.tex) by `make paper2`.

How much of "who was the best footballer of 2020–2026" can public match data decide, and
how much of what happens on the pitch do the statistics not reach? The study starts from a
48-player ranking produced by another AI model and rebuilds every player estimate from raw
data.

## Data

- Every match from 1 January 2020 to 31 August 2026 in the
  [transfermarkt-datasets](https://github.com/dcaribou/transfermarkt-datasets) snapshot:
  line-ups, substitutions, goals, cards.
- [StatsBomb open data](https://github.com/statsbomb/open-data) for the tournaments that
  snapshot lacks.
- Five MLS player-seasons from [American Soccer Analysis](https://www.americansocceranalysis.com/)
  (CC BY-SA 4.0).

No raw or processed data is in this repository; the code downloads it and records SHA-256
manifests. Sources, licences and what is missing are in
[`docs/unmeasured/data-licences.md`](docs/unmeasured/data-licences.md).

## Method

Eight hypotheses and the analysis were
[pre-registered](paper-unmeasured/preregistration.md) before any player-level number
existed. The 25 dated amendments say which were made before and which after a result; the
git history is the timestamp.

Nine modules measure sampling noise, the dependence between metrics, on-pitch impact
(regularised adjusted plus-minus), the share of that impact the statistics cannot see, the
spread over 5,760 definitions of "best", what the Ballon d'Or vote rewards, big-game
performance, and a synthesis that mixes definitions, bootstrap replicates and the unmeasured
part. Every estimator is first tested on synthetic leagues with a planted truth.

## What it finds

- The registered analysis decides the hypotheses and is reported in full, but its ranking is
  not the paper's answer: three measured flaws of the method produced its leaders (no
  adjustment for league strength, an impact measure contaminated by teammates, and one
  impact ranking counted about eight times).
- The paper's main ranking is a corrected mixture, post hoc and labelled as such, whose
  rules were fixed before it was computed and whose league levels are checked against club
  results and UEFA coefficients.
- Its first five places are stable across its sensitivities, yet no outfield player is a
  likely number one and few pairwise orderings are decided.
- It is close to a ranking of attacking production. For defenders, most of what they do on
  the pitch is not in these statistics: that is the unmeasured remainder of the title.

## Reproducing

Downloads are cached; the analyses take hours.

```bash
make install           # uv sync --extra dev
make verify            # compile, lint, mypy --strict, tests
make players-data      # Transfermarkt, StatsBomb, panel, MLS fill
make players-results   # every analysis, master seed 20261114
make paper2            # numbers, tables, figures and the PDF
```

No number in the paper is typed by hand: `scripts/players/make_paper2.py` writes every
macro, table and figure from `results/players/`.

## Repository layout

| Path | Contents |
|---|---|
| `src/footy/players/` | Pure estimators (no I/O; randomness only through an explicit generator) |
| `scripts/players/` | Data acquisition, staged runners, the paper generator |
| `tests/players/` | Tests on synthetic leagues and small synthetic fixtures |
| `paper-unmeasured/` | The paper, the pre-registration, curated inputs with their sources |
| `docs/unmeasured/` | Literature notes, the taxonomy of football variables, licences, league strength |
| `docs/superpowers/specs/` | The study design |

## History

This study began in the repository of an earlier, unrelated one,
[The De-margining Artifact](https://github.com/Bardakor/The-De-margining-Artifact), and moved
here with its full commit history, so the dates of the pre-registration and of each
amendment are preserved. The commits before 14 November 2026 belong to that earlier study.

## Licence

Code: MIT, see [LICENSE](LICENSE). Data keep their own licences
([`docs/unmeasured/data-licences.md`](docs/unmeasured/data-licences.md)).
