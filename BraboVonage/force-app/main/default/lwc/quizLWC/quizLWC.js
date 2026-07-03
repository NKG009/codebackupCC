import { LightningElement } from 'lwc';

export default class QuizLWC extends LightningElement {
    showmodal=false;

    questions = [
        {serial: "Question 1.",
        question: "Which is not the lwc directives?",
        options:[
            {serial:'a',
            label:'<template>',
            value:'<template>'
            },
            {serial:'b',
            label:'<apex>',
            value:'<apex>'
            },
            {serial:'c',
            label:'<p>',
            value:'<p>'
            }],
        answer:"b"
        },
        {serial: "Question 2.",
        question: "Select the file which is not the part of lwc bundle",
        options:[
            {serial:'a',
            label:'.apex',
            value:'.apex'
            },
            {serial:'b',
            label:'.js',
            value:'.js'
            },
            {serial:'c',
            label:'.svg',
            value:'.svg'
            }],
        answer:"a"
        },
        {serial: "Question 3.",
        question: "We can use formula expressions in .html file in lwc components?",
        options:[
            {serial:'a',
            label:'True',
            value:true
            },
            {serial:'b',
            label:'False',
            value:false
            }],
        answer:"b"
        }
    ]

    handletakequiz(event){
        this.showmodal=true;
    }
}