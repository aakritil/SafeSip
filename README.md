# SafeSip: Excessive alcohol consumption management with deep learning and motion sensors 

Excessive alcohol consumption can have severe health consequences. SafeSip uses machine learning to warn users when their consumption has reached unsafe levels, with no need for user input. 

## Inspiration

As college students, we are witness to a lot of drinking. While fine in moderation, excessive alcohol consumption has serious consequences. We want to help our peers strike a good balance between fun and safety. That’s why we’ve created SafeSip, a low-commitment, easy-to-use tool to ensure safe drinking. 

## What it does

By analyzing users’ gait from smartphone accelerometer data, SafeSip provides an accurate estimate of a user’s intoxication level and warns them to stop alcohol consumption before serious consequences begin. 

Existing solutions require significant user input, such as manually entering every drink. Yet, as users drink more, they become increasingly careless, either forgetting or choosing not to track drinks, rendering these solutions ineffective. With SafeSip, users only have to press a button to indicate that they have started drinking, and our technology takes care of the rest. SafeSip extends existing research in the field, using machine learning methods to infer transdermal alcohol content (TAC) from accelerometer data. This is something entirely novel: while existing literature has suggested the possibility of doing so, SafeSip is the first working implementation. 

By accurately estimating a user’s TAC, SafeSip is able to preempt and stop excessive alcohol consumption, preventing unfortunate consequences like blackouts. Further, SafeSip has in-app tools to track historical alcohol consumption and provide safe-drinking education. With SafeSip, users can ensure that they have a safe and enjoyable drinking experience. 

## How we built it

SafeSip is built with an array of different technologies. The native iOS app itself is built in Swift, collecting and streaming movement data using Apple’s Core Motion framework. Our app is connected to the Firebase backend, which handles authentication and storage. A neural network built with PyTorch and hosted on Google Cloud Compute performs the TAC prediction. 

## Challenges we ran into

Data Wrangling: The dataset we used to train our model was quite unruly. Values were in different formats, timestamps didn’t match up, and data was everywhere. Wrangling and getting everything into a usable format took considerable thought and troubleshooting. 

New to iOS: This was our first time ever building an iOS app. We’re proud to have gone from knowing nothing about Swift to having a working App in 36 hours. 

## Accomplishments that we're proud of

For three of our four members, this was our first-ever hackathon! We’re proud to have made it through. 

Making something new! SafeSip is something novel. No one has ever done what we’ve done with deploying real-time TAC-level prediction models leveraging ML and accelerometer data. We’re excited to contribute to the literature on this problem. 

Learning new tech: This was our first time working with Swift, and front-end technologies in native iOS. We’re very happy with how much we learned, and how the end product looks. 

## What we learned

Swift: We’re new to Swift, and we had a lot of fun learning this new tech. 

Hackathons: We learned how to navigate and manage hackathons. 

## What's next for SafeSip

More Features: We think there’s a lot more room for new features in SafeSip. A few ideas we had were pass-out detection, which would call an emergency contact once you passed out, or alcoholism alerts, which would alert you if you were drinking too frequently or heavily. We’re excited by our technology, and think there’s a lot of room for us to make drinking safer. 

Apple Watch Integration: By integrating with an Apple Watch, we could pull more biometric data, allowing us to better estimate TAC, and make more accurate black-out predictions. 

Broader Integration with Different Wearable Devices: We plan to generalize to other brands of wearable devices leveraging platforms like TerraAPI so that we can provide our services to a broader range of users. 
