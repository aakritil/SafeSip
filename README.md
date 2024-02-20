# SafeSip: Alcohol black out warning and blood alcohol detector with deep learning and motion sensors 

Excessive alcohol consumption can jeopardize personal safety. SafeSip uses machine learning to warn users when their consumption has reached unsafe levels, based on accelerometer movement data.

<img src="https://github.com/aakritil/treehacks/assets/63487762/f23c82db-b458-42cc-bde5-f556f5964147" width="500" height="350" alt="Landing Pages">

<img src="https://github.com/aakritil/treehacks/assets/63487762/5124b4cd-dc71-4f23-ab91-13d03d87a7cb" width="160" height="350" alt="Main Page">

<img src="https://github.com/aakritil/treehacks/assets/63487762/e4d859fa-d9a2-4663-a26b-a978ddd32fa8" width="160" height="350" alt="Schedule Page">


View our DevPost [here!](https://devpost.com/software/safesip-umodkf)

## Inspiration

College students are uniquely vulnerable to the dangers of excessive alcohol consumption. Blacking out substantially raises the risk of [sexual assault, injury, and legal consequences](https://onlinelibrary.wiley.com/doi/10.1111/acer.15157), especially for younger students. That’s why we’ve created SafeSip, the first low-commitment, easy-to-use app to ensure safe drinking. SafeSip intelligently notifies users if they are likely to black out, based on their movements, giving users the tools they need to stay safe _before_ tragedy strikes.

## What it does

By analyzing users’ gait from smartphone accelerometer data, SafeSip provides an accurate estimate of a user’s intoxication level and warns them to stop alcohol consumption before serious consequences begin. 

Existing solutions require significant user input, such as [manually entering every drink](https://apps.apple.com/us/app/drinkcontrol-alcohol-tracker/id456207840). Yet, as users drink more, they become increasingly careless, either forgetting or choosing not to track drinks, rendering these solutions ineffective. With SafeSip, users only have to press a button to indicate that they have started drinking, and our technology takes care of the rest. SafeSip extends existing research in the field, using machine learning methods to infer transdermal alcohol content (TAC) from accelerometer data. This is something entirely novel: while [existing literature](https://ceur-ws.org/Vol-2429/paper6.pdf) has suggested the possibility of doing so, **SafeSip is the first working implementation**. 

By accurately estimating a user’s TAC, SafeSip is able to preempt and stop excessive alcohol consumption, preventing students from blacking out. Studies show that people [are not aware of the amount they consume while drinking](https://onlinelibrary.wiley.com/doi/pdf/10.1111/dar.13215?casa_token=QKxCYOE25RMAAAAA:IJIrYo8mXYe747S0-qIYAMbekNd7x3GUks8OXxxKCQy9GIoGL_lJ-WMtkUVNS18NQF4k1qaTlOT-uA), and informing them can prevent blackouts.

Further, SafeSip has in-app tools to track historical alcohol consumption and provide safe-drinking education. With SafeSip, users can ensure that they have a safe and enjoyable drinking experience. SafeSip also prioritizes friends-and-family support, spurring conversations that [disrupt perceived support for blackout drinking](https://pubmed.ncbi.nlm.nih.gov/32224219/).


## How we built it

SafeSip is built with an array of different technologies. The native iOS app itself is built in Swift, collecting and streaming movement data using Apple’s Core Motion framework. Our app is connected to the Firebase backend, which handles authentication and storage. A neural network built with PyTorch and hosted on Google Cloud Compute performs the novel TAC prediction. 

## Challenges we ran into

Data Wrangling: The dataset we used to train our model was quite unruly. Values were in different formats, timestamps didn’t match up, and data was everywhere. Wrangling and getting everything into a usable format took considerable thought and troubleshooting, requiring us to return to first principles. 

New to iOS: This was our first time ever building an iOS app. We’re proud to have gone from knowing nothing about Swift to having a working App in 36 hours. 

## Accomplishments that we're proud of

For three of our four members, this was our first-ever hackathon! We’re proud to have made it through. 

Making something new! SafeSip is something novel. No one has ever done what we’ve done with deploying real-time TAC-level prediction models leveraging ML and accelerometer data. We’re excited to contribute to the literature on this problem. 

Learning new tech: This was our first time working with Swift, and front-end technologies in native iOS. We’re very happy with how much we learned, and how the end product looks. 

## What we learned

Swift: We’re new to Swift, and we had a lot of fun learning this new tech. 

Hackathons: We learned how to navigate and manage hackathons. 

Production-grade ML: We improved on impractical laboratory techniques to create a practical tool that balances speed and performance.

## What's next for SafeSip

More Features: We think there’s a lot more room for new features in SafeSip. A few ideas we had were pass-out detection, which would call an emergency contact once you passed out, using [physiological factors](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3093974/) to distinguish it from sleep. We also thought of alcoholism alerts, which would alert you if you were drinking too frequently or heavily, based on [CDC guidelines](https://www.cdc.gov/alcohol/faqs.htm). We’re excited by our technology, and think there’s a lot of room for us to make drinking safer. 

Apple Watch Integration: By integrating with an Apple Watch, we could pull more biometric data, such as heart rate and temperature, allowing us to better estimate TAC, and make more accurate black-out predictions. 

Broader Integration with Different Wearable Devices: We plan to generalize to other brands of wearable devices leveraging platforms like TerraAPI so that we can provide our services to a broader range of users. 

CarPlay integration: we could potentially use SafeSip to integrate with CarPlay, ensuring that heavily intoxicated users do not drive. This could be paired with [easy access to an Uber/Lyft](https://www.uber.com/us/en/u/reasons-to-ride/) to ensure user safety.
