# Project Proposal
***Comp257 - Friday(1pm) - Group D***

## Predicting Formula 1 Drivers Salary based on pervious years performance

### Project Summary

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/F1.svg/799px-F1.svg.png" width=800 />

Formula 1 also know as F1, is one of the most elite sports in the world. The first F1 season was held in 1950 which means the sport has a legacy of over half a century. In 1950 there were a total of 7 races that made up the season and now in 21 the competition has expanded globally to 21 races.

We will be closely monitoring how factors such as driver age, number of world championships, pole positions and race wins will ultimately affect the drivers salary in the coming year.

### Project Goal
- Find race factors that most impact a drivers salary.
- Model previous F1 driver salaries.
- Predict 2019 driver salaries based on drivers' previous performance.

### Data Sources Summary
#### Driver Salary Data
Our data has been collected from various sources including outlets such as Forbes, the BBC, Crash.net (one of the oldest motorsport website in the world) and other sources. Most annual wages are estimated as drivers will received a higher bonus – if they perform above expectations.

#### Ergast Developer API
> The Ergast Developer API is an experimental web service which provides a historical record of motor racing data for non-commercial purposes.

> The API provides data for the Formula One series, from the beginning of the world championships in 1950.

*[Ergast Developer API](http://ergast.com/mrd/?fbclid=IwAR1giD7DxhujDLdjom8lL1WDPRCjpK2LVBegBVZ8NldsKuaTjnY1ndtZI_I)*

We will be using this data as our main source for each drivers season and race data to compare against their salaries for each season. The website also provides a direct dump of the data in CSV or MySQL format. We will be downloading this data as a CSV and then using pandas to transform it into a format we like.

### Data Manipulation Processes
#### Ergast Data Manipulation
As this data came as a database in CSV format that was heavily normalised, it needed to be transformed into a format where it was more accessible and usable for us.

To start I had to filter the data down so that we only had the 2013-2018 relevant data, This was done by:
1. filtering down to the races that happened in this time period.
2. Finding the results, lap times, pit stops, etc for those races.
3. Finding the drivers and constructors that competed in those races from the results of those races.
4. Finding which circuits *(tracks)* that those races took place on.

We will then need to match the data from the Ergast DB to our salary data that we have scraped from various websites, this will be done by matching the salary data onto the driverId's provided by Ergast.

Finally once we have the data we need, we can use it to get a range of predictors and features about each driver and their performance through the years.

*If you would like to see this process check out [Data Manipulation Process.ipynb](https://github.com/MQCOMP257/data-science-project-comp_pract_02-fri-1pm-_group-d/blob/master/Data%20Manipulation%20Process.ipynb)*



### Data Analysis Techniques
- Correlation Matrix
- Recursive Feature Elimination
- Linear and multiple regression
- K Nearest Neighbor
- Clustering

### Project Plan
![Project Gantt Chart](https://i.imgur.com/lSSQLb8.png)

#### Milestone 1: Project Fundamentals (Week 4 - Week 8)
- Get data
- data manipulation
- Initial exportation (Correlation Matrix?)

#### Milestone 2: RFE & Linear/Multiple Regression (Week 8 - Week 10)
- Multiple regression based on features from our correlation matrix
- Linear recession on the most significant feature (highest correlation)
- RFE on both linear and multiple regression

#### Milestone 3: Clustering and Finalisation (Week 10 - Week 12)
- Perform clustering on the data.
- Predict 2019 Driver Salaries
- Finalise the project ready for submission.
