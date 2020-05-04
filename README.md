# SmartTrash Project

[Summer 2019] VMware High School Immersion Program Mini Hackathon - 1st Place Team Submission

## Inspiration
The idea for our app sprung from the shared experiences from our team of hackers. One member had a close friend from Seattle who unfortunately contracted the COVID-19 virus. Due to misinformation and confusion regarding the symptoms, she did not know until it was too late. After she recovered, she realized that she had spread it to around 15 people that she knew of. Since she informed them late, they did not get a chance to isolate themselves before they had infected close loved ones.

The reason we decided to go anonymous was due to how quickly rumors and misinformation spread, and how they lead to many social consequences. One person at our school was sick for an unrelated reason, and had to miss school for 2 days. Rumors were spread that she had COVID-19, and many people distanced themselves from her even though she didn't have any disease.

## What it does
Our goal was simplicity: All you do is select the symptoms that you’re exhibiting, then select the people you were near. The app will automatically inform those people (using a number we provide, for your anonymity). It will also give them, and you, instruction on the next steps you need to take.

## How we built it
The app was built in XCode, apple’s app development IDE, and using the Swift language We used apple’s pre built contacts API to get all the contacts data we needed Then we used the Twilio API to send the messages These messages are sent using a number that is is no way traceable back to the initial user Thank you to the Twilio team for the free credits for this project!

## Challenges we ran into
We are all high schoolers, so we were relatively inexperienced going into this. There were a lot of problems with the integration of the Twilio API with swift. The SDK did not have what we were looking for, so we had to use REST Apis to get the job done. Another major problem that set us back a few hours was that my laptop started updating, and there was a glitch so it deleted many of my files. Restoring them from a backup added to the stress and tiredness we were all already feeling that night

## What we learned
We learned a lot about the CDC's handling of this as well as the politics behind the response while researching. We also learnt how to send and receive requests using REST api's. Most importantly, we learnt how to collaborate on an iOS app, because the IDE we were using made it quite difficult to do so.

## What's next for BioPneuma
We are hoping that this crisis ends soon. Once it does, we hope to branch out with BioPneuma, and hopefully use it for all kinds of situations where it may be in the best interest of everyone to keep the sender anonymous.

## Authors
Built by Kevin C, Ishan J, Yash J, Aryan M, Kaushik I, Jansen M, Arnav S - official submission can be found [here.](https://www.youtube.com/watch?v=nLJatRdyQJY)
